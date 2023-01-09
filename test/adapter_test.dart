import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  group('adapter', () {
    test('request', () async {
      final a = await wgpu.Adapter.request();
      expect(a.isValid, isTrue);
      expect(a.limits.maxBindGroups, greaterThanOrEqualTo(4));

      a.destroy();
      expect(a.isValid, isFalse);
    });
  });
}
