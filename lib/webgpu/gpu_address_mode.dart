/// Describes the behavior of the Sampler if the sample footprint extends beyond
/// the bounds of the sampled Texture.
enum GPUAddressMode {
  /// Texture coordinates are clamped between 0.0 and 1.0, inclusive.
  clampToEdge,

  /// Texture coordinates wrap to the other side of the texture.
  repeat,

  /// Texture coordinates wrap to the other side of the texture, but the texture
  /// is flipped when the integer part of the coordinate is odd.
  mirrorRepeat;

  static GPUAddressMode fromString(String s) {
    switch (s) {
      case "clamp-to-edge":
        return GPUAddressMode.clampToEdge;
      case "repeat":
        return GPUAddressMode.repeat;
      case "mirror-repeat":
        return GPUAddressMode.mirrorRepeat;
    }
    throw Exception('Invalid value for GPUAddressMode');
  }

  int get nativeIndex => index + 1;
}
