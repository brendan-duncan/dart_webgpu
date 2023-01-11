import '_map_util.dart';
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

  factory FragmentState.fromMap(Map<String, Object> map) {
    final module = getMapValueRequired<ShaderModule>(map, 'module');
    final entryPoint = getMapValueRequired<String>(map, 'entryPoint');
    final constants = getMapValue<Map<String, num>?>(map, 'constants', null);
    final t = map['targets'];
    final targets = t is List<ColorTargetState>
        ? t
        : t is List<Map<String, Object>>
            ? List<ColorTargetState>.generate(
                t.length, (i) => ColorTargetState.fromMap(t[i]))
            : throw Exception('Invalid targets data for FragmentState');

    return FragmentState(
        module: module,
        entryPoint: entryPoint,
        constants: constants,
        targets: targets);
  }
}
