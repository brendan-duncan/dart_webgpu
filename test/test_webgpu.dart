import 'dart:typed_data';

//import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  wgpu.initializeWebGPU(debug: true);

  //test('webgpu', () async {
    final adapter = await wgpu.Adapter.request();
    final device = await adapter.requestDevice();

    device.lost.then((info) {
      print('DEVICE LOST! ${info.message}');
    });

    device.uncapturedError.add((device, type, message) {
      print('ERROR: $message');
    });

    final firstMatrix = Float32List.fromList([
      2 /* rows */, 4 /* columns */,
      1, 2, 3, 4,
      5, 6, 7, 8]);

    final gpuBufferFirstMatrix = device.createBuffer(
      mappedAtCreation: true,
      size: firstMatrix.lengthInBytes,
      usage: wgpu.BufferUsage.storage);

    final rangeFirstMatrix = gpuBufferFirstMatrix.getMappedRange();
    rangeFirstMatrix.as<Float32List>().setAll(0, firstMatrix);
    gpuBufferFirstMatrix.unmap();

    final secondMatrix = Float32List.fromList([
      4 /* rows */, 2 /* columns */,
      1, 2,
      3, 4,
      5, 6,
      7, 8]);

    final gpuBufferSecondMatrix = device.createBuffer(
      mappedAtCreation: true,
      size: secondMatrix.lengthInBytes,
      usage: wgpu.BufferUsage.storage);
    final rangeSecondMatrix = gpuBufferSecondMatrix.getMappedRange();
    rangeSecondMatrix.as<Float32List>().setAll(0, secondMatrix);
    gpuBufferSecondMatrix.unmap();

    // Result Matrix

    final resultMatrixBufferSize = Float32List.bytesPerElement *
        (2 + firstMatrix[0].toInt() * secondMatrix[1].toInt());

    final resultMatrixBuffer = device.createBuffer(
      size: resultMatrixBufferSize,
      usage: wgpu.BufferUsage.storage | wgpu.BufferUsage.copySrc);

    final layout = device.createBindGroupLayout(entries: [
      {
        'binding': 0,
        'visibility': wgpu.ShaderState.compute,
        'buffer': { 'type': wgpu.BufferBindingType.readOnlyStorage }
      },
      {
        'binding': 1,
        'visibility': wgpu.ShaderState.compute,
        'buffer': { 'type': wgpu.BufferBindingType.readOnlyStorage }
      },
      {
        'binding': 2,
        'visibility': wgpu.ShaderState.compute,
        'buffer': { 'type': wgpu.BufferBindingType.storage }
      }
    ]);
    //expect(layout.isValid, isTrue);

    final bindGroup = device.createBindGroup(layout: layout, entries: [
      { 'binding': 0, 'resource': gpuBufferFirstMatrix },
      { 'binding': 1, 'resource': gpuBufferSecondMatrix },
      { 'binding': 2, 'resource': resultMatrixBuffer },
    ]);
    //expect(bindGroup.isValid, isTrue);

    final shaderModule = device.createShaderModule(
      code: '''
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
    //expect(pipelineLayout.isValid, isTrue);

    //final computePipeline = await device.createComputePipelineAsync(
    final computePipeline = device.createComputePipeline(
        layout: pipelineLayout,
        module: shaderModule,
        entryPoint: "main");
    //expect(computePipeline.isValid, isTrue);

    final workgroupCountX = (firstMatrix[0] / 8).ceil();
    final workgroupCountY = (secondMatrix[1] / 8).ceil();

    final commandEncoder = device.createCommandEncoder();

    commandEncoder.beginComputePass()
    ..setPipeline(computePipeline)
    ..setBindGroup(0, bindGroup)
    ..dispatchWorkgroups(workgroupCountX, workgroupCountY)
    ..end();

    final gpuReadBuffer = device.createBuffer(
      size: resultMatrixBufferSize,
      usage: wgpu.BufferUsage.copyDst | wgpu.BufferUsage.mapRead);

    // Encode commands for copying buffer to buffer.
    commandEncoder.copyBufferToBuffer(
        source: resultMatrixBuffer,
        destination: gpuReadBuffer);

    final gpuCommands = commandEncoder.finish();
    device.queue.submit(gpuCommands);

    await gpuReadBuffer.mapAsync(mode: wgpu.MapMode.read);
    final data = gpuReadBuffer.getMappedRange().as<Float32List>();
    print(data);
  print(gpuReadBuffer);
  //});
}
