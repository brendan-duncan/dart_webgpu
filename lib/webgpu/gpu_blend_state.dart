import '_map_util.dart';
import 'gpu_blend_component.dart';

/// Describe how the color or alpha components of a fragment are blended.
class GpuBlendState {
  final GpuBlendComponent color;
  final GpuBlendComponent alpha;

  const GpuBlendState({required this.color, required this.alpha});

  factory GpuBlendState.fromMap(Map<String, Object> map) {
    final color = getMapObject<GpuBlendComponent>(map['color']);
    final alpha = getMapObject<GpuBlendComponent>(map['alpha']);

    return GpuBlendState(color: color, alpha: alpha);
  }
}
