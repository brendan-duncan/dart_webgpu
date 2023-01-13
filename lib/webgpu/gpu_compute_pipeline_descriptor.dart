import '_map_util.dart';
import 'gpu_pipeline_layout.dart';
import 'gpu_shader_module.dart';

class GPUComputePipelineDescriptor {
  final GPUPipelineLayout layout;
  final GPUShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;

  const GPUComputePipelineDescriptor(
      {required this.layout,
      required this.module,
      required this.entryPoint,
      this.constants});

  factory GPUComputePipelineDescriptor.fromMap(Map<String, Object> map) {
    final layout = mapValueRequired<GPUPipelineLayout>(map['layout']);
    final module = mapValueRequired<GPUShaderModule>(map['module']);
    final entryPoint = mapValueRequired<String>(map['entryPoint']);
    final constants = mapValueNullable<Map<String, num>>(map['constants']);

    return GPUComputePipelineDescriptor(
        layout: layout,
        module: module,
        entryPoint: entryPoint,
        constants: constants);
  }
}
