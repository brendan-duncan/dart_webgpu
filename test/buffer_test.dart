import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  group('buffer', () {
    test('createBuffer', () async {
      final a = await wgpu.Adapter.request();
      final d = await a.requestDevice();

      final b = d.createBuffer(size: 4, usage: wgpu.BufferUsage.mapWrite);
      expect(b.isValid, isTrue);

      await b.mapAsync(mode: wgpu.MapMode.write);
      final data = b.getMappedRange().as<Float32List>();
      data[0] = 0.5;
      b.unmap();

      a.destroy();
      expect(b.isValid, isFalse);
    });
  });
}
