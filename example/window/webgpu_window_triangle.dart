import 'package:webgpu/webgpu.dart' as wgpu;

void main() async {
  // Optionally use the Debug build of the webgpu libs for debugging.
  wgpu.initializeWebGPU(debug: true);

  final adapter = await wgpu.Adapter.request();
  final device = await adapter.requestDevice();

  device.uncapturedError.add((device, type, message) {
    print('ERROR: $message');
  });

  final window = wgpu.Window(width: 800, height: 600);
  final context = window.createContext(device);
  final presentationFormat = context.preferredFormat;

  const triangleVertWGSL = '''
    @vertex
    fn main(@builtin(vertex_index) VertexIndex : u32) ->
        @builtin(position) vec4<f32> {
      var pos = array<vec2<f32>, 3>(
        vec2(0.0, 0.5),
        vec2(-0.5, -0.5),
        vec2(0.5, -0.5)
      );
    
      return vec4<f32>(pos[VertexIndex], 0.0, 1.0);
    }''';

  const redFragWGSL = '''
    @fragment
    fn main() -> @location(0) vec4<f32> {
      return vec4(1.0, 0.0, 0.0, 1.0);
    }''';

  final pipeline = device.createRenderPipeline(wgpu.RenderPipelineDescriptor(
    vertex: wgpu.VertexState(
        module: device.createShaderModule(code: triangleVertWGSL),
        entryPoint: 'main'),
    fragment: wgpu.FragmentState(
      module: device.createShaderModule(code: redFragWGSL),
      entryPoint: 'main',
      targets: [
        wgpu.ColorTargetState(format: presentationFormat),
      ],
    ),
    primitive: const wgpu.PrimitiveState(),
  ));

  while (!window.shouldQuit) {
    final textureView = context.getCurrentTextureView();

    final commandEncoder = device.createCommandEncoder();

    commandEncoder.beginRenderPass(wgpu.RenderPassDescriptor(colorAttachments: [
      wgpu.RenderPassColorAttachment(
          view: textureView,
          clearValue: [0.8, 0.6, 0.2, 1.0],
          loadOp: wgpu.LoadOp.clear,
          storeOp: wgpu.StoreOp.store)
    ]))
      ..setPipeline(pipeline)
      ..draw(3)
      ..end();

    final commandBuffer = commandEncoder.finish();
    device.queue.submit(commandBuffer);
    context.present();
    window.pollEvents();
  }
}
