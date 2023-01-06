import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  test('webgpu', () async {
    final adapter = await wgpu.Adapter.request();

    final device = await adapter.requestDevice(
        requiredFeatures: adapter.features,
        requiredLimits: adapter.limits);

    final gpuWriteBuffer = device.createBuffer(size: 4,
        usage: wgpu.BufferUsage.mapWrite | wgpu.BufferUsage.copySrc,
        mappedAtCreation: true);

    expect(gpuWriteBuffer.mappedState, equals(wgpu.MappedState.mapped));

    {
      final range = gpuWriteBuffer.getMappedRange();
      final p = range.as<Float32List>();
      p[0] = 5.0;
      print(p);
      device.pushErrorScope(wgpu.ErrorFilter.validation);
      gpuWriteBuffer.unmap();
      device.popErrorScopeAsync((device, type, message) {
        print('ERROR [1]: $message}');
      });
      expect(gpuWriteBuffer.mappedState, equals(wgpu.MappedState.unmapped));
    }

    device.pushErrorScope(wgpu.ErrorFilter.validation);
    final layout = device.createBindGroupLayout(entries: [{
      'binding': 0,
      'visibility': wgpu.ShaderState.compute,
      'buffer': { 'type': wgpu.BufferBindingType.storage }
    }]);

    /*final layout = device.createBindGroupLayout(entries: [
      wgpu.BindGroupLayoutEntry(binding: 0,
          visibility: wgpu.ShaderState.compute,
          buffer: wgpu.BufferBindingLayout(
              type: wgpu.BufferBindingType.storage))
    ]);*/
    device.popErrorScopeAsync((device, type, message) {
      print('ERROR [2]: $message}');
    });
    expect(layout.isValid, isTrue);

    /*final gpuReadBuffer = device.createBuffer(size: 4,
        usage: wgpu.BufferUsage.mapRead | wgpu.BufferUsage.copyDst);

    final encoder = device.createCommandEncoder()
    ..copyBufferToBuffer(source: gpuWriteBuffer, destination: gpuReadBuffer);
    final commandBuffer = encoder.finish();
    device.queue.submit(commandBuffer);

    {
      device.pushErrorScope(wgpu.ErrorFilter.validation);
      await gpuReadBuffer.mapAsync(mode: wgpu.MapMode.read);
      device.popErrorScopeAsync((device, type, message) {
        print('ERROR [2]: $message}');
      });
      print(gpuReadBuffer.mappedState);
      //expect(gpuReadBuffer.mappedState, wgpu.MappedState.mapped);

      device.pushErrorScope(wgpu.ErrorFilter.validation);
      final range2 = gpuReadBuffer.getMappedRange();
      final p2 = range2.as<Float32List>();
      device.popErrorScopeAsync((device, type, message) {
        print('ERROR [3]: $message}');
      });
      print('########### $p2');
    }*/
  });
}
