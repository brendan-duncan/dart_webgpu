import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';

void main() async {
  await initialize();
  group('adapter', () {
    test('request', () async {
      final a = await GpuAdapter.request();
      expect(a.isValid, isTrue);
      expect(a.limits.maxBindGroups, greaterThanOrEqualTo(4));

      a.destroy();
      expect(a.isValid, isFalse);
    });
  });
}
