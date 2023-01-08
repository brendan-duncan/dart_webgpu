/// Describe the behavior of the sampler if the sample footprint does not
/// exactly match one texel.
enum FilterMode {
  undefined,

  /// Return the value of the texel nearest to the texture coordinates.
  nearest,

  /// Select two texels in each dimension and return a linear interpolation
  /// between their values.
  linear
}
