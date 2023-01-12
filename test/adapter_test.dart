import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  await wgpu.initialize();
  group('adapter', () {
    test('request', () async {
      final a = await wgpu.GpuAdapter.request();
      expect(a.isValid, isTrue);
      expect(a.limits.maxBindGroups, greaterThanOrEqualTo(4));

      a.destroy();
      expect(a.isValid, isFalse);
    });
  });
}
