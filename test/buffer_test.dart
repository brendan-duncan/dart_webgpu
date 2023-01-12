import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  await wgpu.initialize();
  group('buffer', () {
    test('createBuffer', () async {
      final a = await wgpu.GpuAdapter.request();
      final d = await a.requestDevice();

      final b = d.createBuffer(size: 4, usage: wgpu.GpuBufferUsage.mapWrite);
      expect(b.isValid, isTrue);
      expect(b.mappedState, wgpu.GpuMappedState.unmapped);

      a.destroy();
      expect(b.isValid, isFalse);
    });

    test('map', () async {
      final a = await wgpu.GpuAdapter.request();
      final d = await a.requestDevice();

      final b = d.createBuffer(size: 4, usage: wgpu.GpuBufferUsage.mapRead,
        mappedAtCreation: true);
      expect(b.mappedState, equals(wgpu.GpuMappedState.mapped));
      b.getMappedRange().as<Float32List>()[0] = 0.5;
      b.unmap();
      expect(b.mappedState, wgpu.GpuMappedState.unmapped);

      var mapped = false;
      // await does not work so we have to wait for the callback
      b.mapAsync(mode: wgpu.GpuMapMode.read, callback: () {
        mapped = true;
      });
      while (!mapped) {
        d.queue.submit(); // process pending commands
      }
      expect(b.mappedState, wgpu.GpuMappedState.mapped);
      final data = b.getMappedRange().as<Float32List>();
      expect(data[0], equals(0.5));
      b.unmap();
    });
  });
}
