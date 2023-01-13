import '_map_util.dart';
import 'gpu_color_target_state.dart';
import 'gpu_shader_module.dart';

class GPUFragmentState {
  final GPUShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;
  final List<GpuColorTargetState> targets;

  const GPUFragmentState(
      {required this.module,
      required this.entryPoint,
      this.constants,
      required this.targets});

  factory GPUFragmentState.fromMap(Map<String, Object> map) {
    final module = mapValueRequired<GPUShaderModule>(map['module']);
    final entryPoint = mapValueRequired<String>(map['entryPoint']);
    final constants = mapValueNullable<Map<String, num>>(map['constants']);
    final targets = mapList<GpuColorTargetState>(map['targets']);

    return GPUFragmentState(
        module: module,
        entryPoint: entryPoint,
        constants: constants,
        targets: targets);
  }
}
