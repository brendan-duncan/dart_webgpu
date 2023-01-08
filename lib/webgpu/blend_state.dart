import 'blend_component.dart';

/// Describe how the color or alpha components of a fragment are blended.
class BlendState {
  final BlendComponent color;
  final BlendComponent alpha;

  const BlendState({required this.color, required this.alpha});
}
