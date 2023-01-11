import '_map_util.dart';
import 'pipeline_layout.dart';
import 'shader_module.dart';

class ComputePipelineDescriptor {
  final PipelineLayout layout;
  final ShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;

  const ComputePipelineDescriptor(
      {required this.layout,
      required this.module,
      required this.entryPoint,
      this.constants});

  factory ComputePipelineDescriptor.fromMap(Map<String, Object> map) {
    final layout = getMapValueRequired<PipelineLayout>(map['layout']);
    final module = getMapValueRequired<ShaderModule>(map['module']);
    final entryPoint = getMapValueRequired<String>(map['entryPoint']);
    final constants = getMapValue<Map<String, num>?>(map['constants'], null);

    return ComputePipelineDescriptor(
        layout: layout,
        module: module,
        entryPoint: entryPoint,
        constants: constants);
  }
}
