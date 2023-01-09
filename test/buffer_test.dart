import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  wgpu.initializeWebGPU(debug: true);
  /*group('buffer', () {
    test('createBuffer', () async {
      final a = await wgpu.Adapter.request();
      final d = await a.requestDevice();

      final b = d.createBuffer(size: 4, usage: wgpu.BufferUsage.mapWrite);
      expect(b.isValid, isTrue);
      expect(b.mappedState, wgpu.MappedState.unmapped);

      a.destroy();
      expect(b.isValid, isFalse);
    });

    test('mapAsync', () async {*/
      final a = await wgpu.Adapter.request();
      final d = await a.requestDevice();

      final b = d.createBuffer(size: 4, usage: wgpu.BufferUsage.mapWrite);

      await b.mapAsync(mode: wgpu.MapMode.write);
      expect(b.mappedState, wgpu.MappedState.mapped);
      final data = b.getMappedRange().as<Float32List>();
      data[0] = 0.5;
      b.unmap();
    //});
  //});
}