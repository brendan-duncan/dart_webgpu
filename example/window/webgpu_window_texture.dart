import 'package:image/image.dart' as img;
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
    struct VertexOutput {
      @builtin(position) position : vec4<f32>,
      @location(0) fragUV : vec2<f32>,
    }
    @vertex
    fn main(@builtin(vertex_index) VertexIndex : u32) -> VertexOutput  {
      var pos = array<vec4<f32>, 3>(
        vec4(0.0, 0.5, 0.5, 0.0),
        vec4(-0.5, -0.5, 0.0, 1.0),
        vec4(0.5, -0.5, 1.0, 1.0)
      );
      
      var position = vec4<f32>(pos[VertexIndex].xy, 0.0, 1.0);     
      var output : VertexOutput;
      output.position = position;
      output.fragUV = pos[VertexIndex].zw;
      return output;
    }''';

  const redFragWGSL = '''
    @group(0) @binding(0) var mySampler: sampler;
    @group(0) @binding(1) var myTexture: texture_2d<f32>;
    @fragment
    fn main(@location(0) fragUV: vec2<f32>) -> @location(0) vec4<f32> {
      return textureSample(myTexture, mySampler, fragUV);
    }''';

  final pipeline = device.createRenderPipeline(descriptor: {
    'vertex': {
      'module': device.createShaderModule(code: triangleVertWGSL),
      'entryPoint': 'main'
    },
    'fragment': {
      'module': device.createShaderModule(code: redFragWGSL),
      'entryPoint': 'main',
      'targets': [
        {'format': presentationFormat},
      ],
    }
  });

  final image = (await img.decodePngFile('example/window/res/buck_24.png'))!
      .convert(format: img.Format.uint8, numChannels: 4);

  final texture = device.createTexture(
      width: image.width,
      height: image.height,
      format: wgpu.TextureFormat.rgba8unorm,
      usage: wgpu.TextureUsage.textureBinding | wgpu.TextureUsage.copyDst);

  device.queue.writeTexture(
      destination: {'texture': texture},
      data: image.toUint8List(),
      dataLayout: {
        'bytesPerRow': image.rowStride,
        'rowsPerImage': image.height
      },
      width: image.width,
      height: image.height);

  final sampler = device.createSampler(
      magFilter: wgpu.FilterMode.linear, minFilter: wgpu.FilterMode.linear);

  final bindGroup =
      device.createBindGroup(layout: pipeline.getBindGroupLayout(0), entries: [
    {'binding': 0, 'resource': sampler},
    {'binding': 1, 'resource': texture.createView()},
  ]);

  while (!window.shouldQuit) {
    final textureView = context.getCurrentTextureView();

    final commandEncoder = device.createCommandEncoder();

    commandEncoder.beginRenderPass({
      'colorAttachments': [
        {
          'view': textureView,
          'clearValue': [0.8, 0.6, 0.2, 1.0],
          'loadOp': wgpu.LoadOp.clear,
          'storeOp': wgpu.StoreOp.store
        }
      ]
    })
      ..setPipeline(pipeline)
      ..setBindGroup(0, bindGroup)
      ..draw(3)
      ..end();

    final commandBuffer = commandEncoder.finish();
    device.queue.submit(commandBuffer);
    context.present();
    window.pollEvents();
  }
}
