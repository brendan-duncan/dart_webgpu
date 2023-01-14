import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';

void main() async {
  await initializeWebGPU(config: WGpuConfig.debug);
  group('device', () {
    test('request', () async {
      final a = await GPUAdapter.request();
      final d = await a.requestDevice();
      expect(d.isValid, isTrue);

      a.destroy();
      expect(a.isValid, isFalse);
      // Destroying the Adapter should also destroy the Device, since the
      // Adapter owns the Device.
      expect(d.isValid, isFalse);
    });

    test('deviceLost', () async {
      final a = await GPUAdapter.request();
      final d = await a.requestDevice();

      var deviceWasLost = false;

      d.lost.add((device, reason, message) {
        expect(reason, equals(GPUDeviceLostReason.destroyed));
        expect(device, equals(d));
        deviceWasLost = true;
      });

      a.destroy(); // This should trigger a deviceLost callback
      expect(deviceWasLost, isTrue);
    });

    test('finalizer', () async {
      final a = await GPUAdapter.request();
      final d = await a.requestDevice();

      // Make sure the test doesn't crash if a lost callback is registered
      // and the device is closed because of a Finalizer
      d.lost.add((device, reason, message) {
        expect(reason, equals(GPUDeviceLostReason.destroyed));
        expect(device, equals(d));
      });
    });
  });
}
