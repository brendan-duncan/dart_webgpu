/// Indicates the type required for TextureViews bound to this binding.
enum GpuTextureSampleType {
  float,
  unfilterableFloat,
  depth,
  sint,
  uint;

  int get nativeIndex => index + 1;
}
