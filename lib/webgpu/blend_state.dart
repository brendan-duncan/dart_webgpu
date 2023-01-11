import 'blend_component.dart';

/// Describe how the color or alpha components of a fragment are blended.
class BlendState {
  final BlendComponent color;
  final BlendComponent alpha;

  const BlendState({required this.color, required this.alpha});

  factory BlendState.fromMap(Map<String, Object> map) {
    final c = map['color'];
    final color = c is BlendComponent
        ? c
        : c is Map<String, Object>
            ? BlendComponent.fromMap(c)
            : throw Exception('Invalid data for BlendState.color');

    final a = map['color'];
    final alpha = a is BlendComponent
        ? a
        : a is Map<String, Object>
            ? BlendComponent.fromMap(a)
            : throw Exception('Invalid data for BlendState.alpha');

    return BlendState(color: color, alpha: alpha);
  }
}
