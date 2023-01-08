/// Indicates the required type of a Sampler bound to this bindings.
enum SamplerBindingType {
  filtering,
  nonFiltering,
  comparison;

  int get nativeIndex => index + 1;
}
