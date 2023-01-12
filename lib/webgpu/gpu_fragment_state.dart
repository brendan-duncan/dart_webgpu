import '_map_util.dart';
import 'gpu_color_target_state.dart';
import 'gpu_shader_module.dart';

class GpuFragmentState {
  final GpuShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;
  final List<GpuColorTargetState> targets;

  const GpuFragmentState(
      {required this.module,
      required this.entryPoint,
      this.constants,
      required this.targets});

  factory GpuFragmentState.fromMap(Map<String, Object> map) {
    final module = getMapValueRequired<GpuShaderModule>(map['module']);
    final entryPoint = getMapValueRequired<String>(map['entryPoint']);
    final constants = getMapValue<Map<String, num>?>(map['constants'], null);
    final targets = getMapList<GpuColorTargetState>(map['targets']);

    return GpuFragmentState(
        module: module,
        entryPoint: entryPoint,
        constants: constants,
        targets: targets);
  }
}
