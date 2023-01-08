import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  // Optionally use the Debug build of the webgpu libs for debugging.
  wgpu.initializeWebGPU(debug: true);

  final adapter = await wgpu.Adapter.request();
  final device = await adapter.requestDevice();

  device.lost.then((info) {
    print('DEVICE LOST! ${info.message}');
  });

  device.uncapturedError.add((device, type, message) {
    print('ERROR: $message');
  });

  final commandEncoder = device.createCommandEncoder();
  device.queue.submit(commandEncoder.finish());
}
