/// Describes the behavior of the Sampler if the sample footprint extends beyond
/// the bounds of the sampled Texture.
enum AddressMode {
  /// Texture coordinates are clamped between 0.0 and 1.0, inclusive.
  clampToEdge,
  /// Texture coordinates wrap to the other side of the texture.
  repeat,
  /// Texture coordinates wrap to the other side of the texture, but the texture
  /// is flipped when the integer part of the coordinate is odd.
  mirrorRepeat;

  int get nativeIndex => index + 1;
}
