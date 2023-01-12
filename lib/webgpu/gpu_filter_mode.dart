/// Describe the behavior of the sampler if the sample footprint does not
/// exactly match one texel.
enum GPUFilterMode {
  /// Return the value of the texel nearest to the texture coordinates.
  nearest,

  /// Select two texels in each dimension and return a linear interpolation
  /// between their values.
  linear;

  static GPUFilterMode fromString(String s) {
    switch (s) {
      case 'nearest':
        return GPUFilterMode.nearest;
      case 'linear':
        return GPUFilterMode.linear;
    }
    throw Exception('Invalid value for GPUFilterMode');
  }

  int get nativeIndex => index + 1;
}
