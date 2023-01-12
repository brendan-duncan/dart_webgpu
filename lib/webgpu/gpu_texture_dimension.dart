enum GPUTextureDimension {
  /// Specifies a texture that has one dimension, width.
  texture1d,

  /// Specifies a texture that has a width and height, and may have layers.
  /// Only "2d" textures may have mipmaps, be multisampled, use a compressed or
  /// depth/stencil format, and be used as a render attachment.
  texture2d,

  /// Specifies a texture that has a width, height, and depth.
  texture3d;

  static GPUTextureDimension fromString(String s) {
    switch (s) {
      case '1d':
        return GPUTextureDimension.texture1d;
      case '2d':
        return GPUTextureDimension.texture2d;
      case '3d':
        return GPUTextureDimension.texture3d;
    }
    throw Exception('Invalid value for GPUTextureDimension');
  }

  int get nativeIndex => index + 1;
}
