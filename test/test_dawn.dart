import 'package:webgpu/webgpu.dart' as webgpu;

void main() async {
  final adapter = await webgpu.Adapter.request(
      webgpu.AdapterOptions());

  print(adapter.features);
  print(adapter.limits);

  final device = await adapter.requestDevice(
      webgpu.DeviceDescriptor(requiredFeatures: adapter.features,
        requiredLimits: adapter.limits));

  final module = device.createShaderModule(webgpu.ShaderModuleDescriptor(
    code: _computeShader
  ));

  print(module);
}

const _computeShader = '''
@group(0) @binding(0) var<storage, read_write> v_indices: array<u32>;
fn collatz_iterations(n_base: u32) -> u32{
  var n: u32 = n_base;
  var i: u32 = 0u;
  loop {
    if (n <= 1u) {
      break;
    }
    if (n % 2u == 0u) {
      n = n / 2u;
    } else {
      if (n >= 1431655765u) {   // 0x55555555u
        return 4294967295u;   // 0xffffffffu
      }
      n = 3u * n + 1u;
    }
    i = i + 1u;
  }
  return i;
}

@compute @workgroup_size(1)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
  v_indices[global_id.x] = collatz_iterations(v_indices[global_id.x]);
}
''';
