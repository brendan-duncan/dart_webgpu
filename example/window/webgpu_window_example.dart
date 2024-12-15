import 'package:webgpu/webgpu.dart';

void main() async {
  final adapter = await GPUAdapter.request();
  final device = await adapter.requestDevice();

  device.lost.add((device, type, message) {
    print(message);
  });

  device.uncapturedError.add((device, type, message) {
    print('ERROR: $message');
  });

  final window = GPUWindow(width: 800, height: 600);
  final context = window.createContext(adapter, device);

  var g = 0.0;

  while (!window.shouldQuit) {
    final textureView = context.getCurrentTextureView();

    final commandEncoder = device.createCommandEncoder();

    commandEncoder.beginRenderPass({
      'colorAttachments': [
        {
          'view': textureView,
          'clearValue': [g, g, g, 1.0],
          'loadOp': 'clear',
          'storeOp': 'store'
        }
      ]
    }).end(); // Nothing was drawn so immediate end the render pass

    g += 0.01;
    if (g > 1.0) {
      g = 0.0;
    }

    final commandBuffer = commandEncoder.finish();
    device.queue.submit(commandBuffer);
    context.present();
    window.pollEvents();
  }
}
