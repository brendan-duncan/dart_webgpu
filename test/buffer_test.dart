import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';

void main() async {
  await initialize();
  group('buffer', () {
    test('createBuffer', () async {
      final a = await GpuAdapter.request();
      final d = await a.requestDevice();

      final b = d.createBuffer(size: 4, usage: GpuBufferUsage.mapWrite);
      expect(b.isValid, isTrue);
      expect(b.mappedState, GpuMappedState.unmapped);

      a.destroy();
      expect(b.isValid, isFalse);
    });

    test('map', () async {
      final a = await GpuAdapter.request();
      final d = await a.requestDevice();

      final b = d.createBuffer(size: 4, usage: GpuBufferUsage.mapRead,
        mappedAtCreation: true);
      expect(b.mappedState, equals(GpuMappedState.mapped));
      b.getMappedRange().as<Float32List>()[0] = 0.5;
      b.unmap();
      expect(b.mappedState, GpuMappedState.unmapped);

      var mapped = false;
      // await does not work so we have to wait for the callback
      b.mapAsync(mode: GpuMapMode.read, callback: () {
        mapped = true;
      });
      while (!mapped) {
        d.queue.submit(); // process pending commands
      }
      expect(b.mappedState, GpuMappedState.mapped);
      final data = b.getMappedRange().as<Float32List>();
      expect(data[0], equals(0.5));
      b.unmap();
    });
  });
}
