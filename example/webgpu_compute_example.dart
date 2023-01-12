import 'dart:typed_data';

import 'package:webgpu/webgpu.dart';

void main() async {
  final adapter = await GPUAdapter.request();
  final device = await adapter.requestDevice();

  device.lost.add((device, type, message) {
    print(message);
  });

  device.uncapturedError.add((device, type, message) {
    print('ERROR: $message');
  });

  // From: https://web.dev/gpu-compute

  final firstMatrix = Float32List.fromList(
      [2 /* rows */, 4 /* columns */, 1, 2, 3, 4, 5, 6, 7, 8]);

  final gpuBufferFirstMatrix = device.createBuffer(
      mappedAtCreation: true,
      size: firstMatrix.lengthInBytes,
      usage: GPUBufferUsage.storage)
    ..getMappedRange().as<Float32List>().setAll(0, firstMatrix)
    ..unmap();

  final secondMatrix = Float32List.fromList(
      [4 /* rows */, 2 /* columns */, 1, 2, 3, 4, 5, 6, 7, 8]);

  final gpuBufferSecondMatrix = device.createBuffer(
      mappedAtCreation: true,
      size: secondMatrix.lengthInBytes,
      usage: GPUBufferUsage.storage)
    ..getMappedRange().as<Float32List>().setAll(0, secondMatrix)
    ..unmap();

  // Result Matrix

  final resultMatrixBufferSize = Float32List.bytesPerElement *
      (2 + firstMatrix[0].toInt() * secondMatrix[1].toInt());

  final resultMatrixBuffer = device.createBuffer(
      size: resultMatrixBufferSize,
      usage: GPUBufferUsage.storage | GPUBufferUsage.copySrc);

  final layout = device.createBindGroupLayout(entries: [
    {
      'binding': 0,
      'visibility': GPUShaderStage.compute,
      'buffer': {'type': GPUBufferBindingType.readOnlyStorage}
    },
    {
      'binding': 1,
      'visibility': GPUShaderStage.compute,
      'buffer': {'type': GPUBufferBindingType.readOnlyStorage}
    },
    {
      'binding': 2,
      'visibility': GPUShaderStage.compute,
      'buffer': {'type': GPUBufferBindingType.storage}
    }
  ]);

  final bindGroup = device.createBindGroup(layout: layout, entries: [
    {'binding': 0, 'resource': gpuBufferFirstMatrix},
    {'binding': 1, 'resource': gpuBufferSecondMatrix},
    {'binding': 2, 'resource': resultMatrixBuffer}
  ]);

  final shaderModule = device.createShaderModule(code: '''
    struct Matrix {
      size : vec2<f32>,
      numbers: array<f32>,
    }

    @group(0) @binding(0) var<storage, read> firstMatrix : Matrix;
    @group(0) @binding(1) var<storage, read> secondMatrix : Matrix;
    @group(0) @binding(2) var<storage, read_write> resultMatrix : Matrix;

    @compute @workgroup_size(8, 8)
    fn main(@builtin(global_invocation_id) global_id : vec3<u32>) {
      // Guard against out-of-bounds work group sizes
      if (global_id.x >= u32(firstMatrix.size.x) ||
          global_id.y >= u32(secondMatrix.size.y)) {
        return;
      }

      resultMatrix.size = vec2(firstMatrix.size.x, secondMatrix.size.y);

      let resultCell = vec2(global_id.x, global_id.y);
      var result = 0.0;
      for (var i = 0u; i < u32(firstMatrix.size.y); i = i + 1u) {
        let a = i + resultCell.x * u32(firstMatrix.size.y);
        let b = resultCell.y + i * u32(secondMatrix.size.y);
        result = result + firstMatrix.numbers[a] * secondMatrix.numbers[b];
      }

      let index = resultCell.y + resultCell.x * u32(secondMatrix.size.y);
      resultMatrix.numbers[index] = result;
    }
    ''');

  final pipelineLayout = device.createPipelineLayout([layout]);

  final computePipeline = device.createComputePipeline(descriptor: {
    'layout': pipelineLayout,
    'module': shaderModule,
    'entryPoint': 'main'
  });

  // We can't read directly from the writable results storage buffer,
  // so we have to copy the results to a buffer we can read from.
  final gpuReadBuffer = device.createBuffer(
      size: resultMatrixBufferSize,
      usage: GPUBufferUsage.copyDst | GPUBufferUsage.mapRead);

  // Create and execute a CommandBuffer to execute the compute shader and
  // copy the results to gpuReadBuffer.

  final workgroupCountX = (firstMatrix[0] / 8).ceil();
  final workgroupCountY = (secondMatrix[1] / 8).ceil();

  final commandEncoder = device.createCommandEncoder();

  // Execute the compute shader
  commandEncoder.beginComputePass()
    ..setPipeline(computePipeline)
    ..setBindGroup(0, bindGroup)
    ..dispatchWorkgroups(workgroupCountX, workgroupCountY)
    ..end();

  // Copy the results storage buffer to a buffer we can read from.
  commandEncoder.copyBufferToBuffer(
      source: resultMatrixBuffer, destination: gpuReadBuffer);

  // Finalize and execute the commands.
  device.queue.submit(commandEncoder.finish());

  gpuReadBuffer.mapAsync(mode: GPUMapMode.read);
  // Pump WebGPU commands while the mapAsync is still pending.
  // This isn't a great solution, still trying to figure out how to get
  // a better solution with Dart since await causes a crash.
  while (gpuReadBuffer.mappedState != GPUMappedState.mapped) {
    device.queue.submit();
  }
  // The GPU buffer has been mapped to the CPU
  final data = gpuReadBuffer.getMappedRange().as<Float32List>();
  print(data);
  gpuReadBuffer.unmap();
}
