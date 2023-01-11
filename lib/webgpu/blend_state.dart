import '_map_util.dart';
import 'blend_component.dart';

/// Describe how the color or alpha components of a fragment are blended.
class BlendState {
  final BlendComponent color;
  final BlendComponent alpha;

  const BlendState({required this.color, required this.alpha});

  factory BlendState.fromMap(Map<String, Object> map) {
    final color = getMapObject<BlendComponent>(map['color']);
    final alpha = getMapObject<BlendComponent>(map['alpha']);

    return BlendState(color: color, alpha: alpha);
  }
}
