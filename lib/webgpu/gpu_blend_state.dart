import '_map_util.dart';
import 'gpu_blend_component.dart';

/// Describe how the color or alpha components of a fragment are blended.
class GPUBlendState {
  final GPUBlendComponent color;
  final GPUBlendComponent alpha;

  const GPUBlendState({required this.color, required this.alpha});

  factory GPUBlendState.fromMap(Map<String, Object> map) {
    final color = getMapObject<GPUBlendComponent>(map['color']);
    final alpha = getMapObject<GPUBlendComponent>(map['alpha']);

    return GPUBlendState(color: color, alpha: alpha);
  }
}
