import 'color_target_state.dart';
import 'shader_module.dart';

class FragmentState {
  final ShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;
  final List<ColorTargetState> targets;

  const FragmentState(
      {required this.module,
      required this.entryPoint,
      this.constants,
      required this.targets});
}
