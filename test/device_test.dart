import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  await wgpu.initialize();
  group('device', () {
    test('request', () async {
      final a = await wgpu.GpuAdapter.request();
      final d = await a.requestDevice();
      expect(d.isValid, isTrue);

      a.destroy();
      expect(a.isValid, isFalse);
      // Destroying the Adapter should also destroy the Device, since the
      // Adapter owns the Device.
      expect(d.isValid, isFalse);
    });

    test('deviceLost', () async {
      final a = await wgpu.GpuAdapter.request();
      final d = await a.requestDevice();

      var deviceWasLost = false;

      d.lost.add((device, reason, message) {
        expect(reason, equals(wgpu.GpuDeviceLostReason.destroyed));
        expect(device, equals(d));
        deviceWasLost = true;
      });

      a.destroy(); // This should trigger a deviceLost callback
      expect(deviceWasLost, isTrue);
    });

    test('finalizer', () async {
      final a = await wgpu.GpuAdapter.request();
      final d = await a.requestDevice();

      // Make sure the test doesn't crash if a lost callback is registered
      // and the device is closed because of a Finalizer
      d.lost.add((device, reason, message) {
        expect(reason, equals(wgpu.GpuDeviceLostReason.destroyed));
        expect(device, equals(d));
      });
    });
  });
}
