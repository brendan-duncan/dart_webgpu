/// Indicates the required type of a Sampler bound to this bindings.
enum GpuSamplerBindingType {
  filtering,
  nonFiltering,
  comparison;

  int get nativeIndex => index + 1;
}
