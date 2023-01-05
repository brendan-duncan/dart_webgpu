import '../ffi/ffi_webgpu.dart' as wgpu;

class ShaderModuleCompilationHint {
  String name;
  wgpu.WGpuPipelineLayout layout;

  ShaderModuleCompilationHint(this.name, this.layout);
}
