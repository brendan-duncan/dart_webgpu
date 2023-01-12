import '_binding_layout_type.dart';
import '_map_util.dart';
import 'gpu_sampler_binding_type.dart';

class GPUSamplerBindingLayout extends GpuBindingLayoutType {
  final GPUSamplerBindingType type;

  const GPUSamplerBindingLayout({this.type = GPUSamplerBindingType.filtering});

  factory GPUSamplerBindingLayout.fromMap(Map<String, Object> map) {
    final type = getMapValue<GPUSamplerBindingType>(
        map['type'], GPUSamplerBindingType.filtering);
    return GPUSamplerBindingLayout(type: type);
  }
}
