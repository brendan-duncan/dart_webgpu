/// Indicates the type required for TextureViews bound to this binding.
enum GPUTextureSampleType {
  float,
  unfilterableFloat,
  depth,
  sint,
  uint;

  static GPUTextureSampleType fromString(String s) {
    switch (s) {
      case 'float':
        return GPUTextureSampleType.float;
      case 'unfilterable-float':
        return GPUTextureSampleType.unfilterableFloat;
      case 'depth':
        return GPUTextureSampleType.depth;
      case 'sint':
        return GPUTextureSampleType.sint;
      case 'uint':
        return GPUTextureSampleType.uint;
    }
    throw Exception('Invalid value for GPUTextureSampleType');
  }

  int get nativeIndex => index + 1;
}
