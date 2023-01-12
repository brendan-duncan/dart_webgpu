import '_map_util.dart';
import 'gpu_pipeline_layout.dart';
import 'gpu_shader_module.dart';

class GpuComputePipelineDescriptor {
  final GpuPipelineLayout layout;
  final GpuShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;

  const GpuComputePipelineDescriptor(
      {required this.layout,
      required this.module,
      required this.entryPoint,
      this.constants});

  factory GpuComputePipelineDescriptor.fromMap(Map<String, Object> map) {
    final layout = getMapValueRequired<GpuPipelineLayout>(map['layout']);
    final module = getMapValueRequired<GpuShaderModule>(map['module']);
    final entryPoint = getMapValueRequired<String>(map['entryPoint']);
    final constants = getMapValue<Map<String, num>?>(map['constants'], null);

    return GpuComputePipelineDescriptor(
        layout: layout,
        module: module,
        entryPoint: entryPoint,
        constants: constants);
  }
}
