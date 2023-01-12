import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';

void main() async {
  await initializeWebGPU();
  group('adapter', () {
    test('request', () async {
      final a = await GPUAdapter.request();
      expect(a.isValid, isTrue);
      expect(a.limits.maxBindGroups, greaterThanOrEqualTo(4));

      a.destroy();
      expect(a.isValid, isFalse);
    });
  });
}
