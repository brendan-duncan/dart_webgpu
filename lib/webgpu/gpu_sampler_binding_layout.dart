import '_binding_layout_type.dart';
import '_map_util.dart';
import 'gpu_sampler_binding_type.dart';

class GpuSamplerBindingLayout extends GpuBindingLayoutType {
  final GpuSamplerBindingType type;

  const GpuSamplerBindingLayout({this.type = GpuSamplerBindingType.filtering});

  factory GpuSamplerBindingLayout.fromMap(Map<String, Object> map) {
    final type = getMapValue<GpuSamplerBindingType>(
        map['type'], GpuSamplerBindingType.filtering);
    return GpuSamplerBindingLayout(type: type);
  }
}
