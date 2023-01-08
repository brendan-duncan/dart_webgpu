import '_binding_layout_type.dart';
import 'sampler_binding_type.dart';

class SamplerBindingLayout extends BindingLayoutType {
  final SamplerBindingType type;
  const SamplerBindingLayout({this.type = SamplerBindingType.filtering});
}
