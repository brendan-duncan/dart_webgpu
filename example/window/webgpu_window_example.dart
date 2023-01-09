import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  // Optionally use the Debug build of the webgpu libs for debugging.
  wgpu.initializeWebGPU(debug: true);

  final adapter = await wgpu.Adapter.request();
  final device = await adapter.requestDevice();

  final window = wgpu.Window(width: 800, height: 600, device: device);

  var g = 0.0;

  while (!window.shouldQuit) {
    final textureView = window.getCurrentTextureView();

    final commandEncoder = device.createCommandEncoder();

    commandEncoder.beginRenderPass(
        wgpu.RenderPassDescriptor(colorAttachments: [
          wgpu.RenderPassColorAttachment(
              view: textureView,
              clearValue: [g, g, g, 1.0],
              loadOp: wgpu.LoadOp.clear,
              storeOp: wgpu.StoreOp.store)
        ]))
    .end(); // Nothing was drawn so immediate end the render pass

    g += 0.01;
    if (g > 1.0) {
      g = 0.0;
    }

    final commandBuffer = commandEncoder.finish();
    //commandEncoder.destroy();

    device.queue.submit(commandBuffer);
    //commandBuffer.destroy();

    window.present();

    //textureView.destroy();
  }
}