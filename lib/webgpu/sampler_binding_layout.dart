import '_binding_layout_type.dart';
import '_map_util.dart';
import 'sampler_binding_type.dart';

class SamplerBindingLayout extends BindingLayoutType {
  final SamplerBindingType type;

  const SamplerBindingLayout({this.type = SamplerBindingType.filtering});

  factory SamplerBindingLayout.fromMap(Map<String, Object> map) {
    final type = getMapValue<SamplerBindingType>(
        map['type'], SamplerBindingType.filtering);
    return SamplerBindingLayout(type: type);
  }
}
