import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';

void main() async {
  await initializeWebGPU();
  group('GPUCommandEncoder', () {
    test('empty', () async {
      final a = await GPUAdapter.request();
      final d = await a.requestDevice();
      expect(d.isValid, isTrue);

      {
        final e = d.createCommandEncoder();
        expect(e.isValid, isTrue);

        {
          final b = e.finish();
          expect(b.isValid, isTrue);
          d.queue.submit(b);
          // submitting a command buffer destroys it.
          expect(b.isValid, isFalse);
        }
      }
      a.destroy();
    });

    test('renderPass', () async {
      final a = await GPUAdapter.request();
      final d = await a.requestDevice();
      final t = d.createTexture(width: 32, height: 32, format: 'rgba8unorm',
          usage: GPUTextureUsage.renderAttachment);
      final e = d.createCommandEncoder();
      expect(e.isValid, isTrue);
      e.beginRenderPass({
        'colorAttachments': [{
          'view': t.createView(),
          'loadOp': 'load',
          'storeOp': 'store'}]
      })
      .end();
      final b = e.finish();
      expect(b.isValid, isTrue);
      d.queue.submit(b);
      expect(b.isValid, isFalse);
    });
  });
}
