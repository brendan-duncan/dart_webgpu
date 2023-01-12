enum GpuTextureDimension {
  /// Specifies a texture that has one dimension, width.
  texture1d,

  /// Specifies a texture that has a width and height, and may have layers.
  /// Only "2d" textures may have mipmaps, be multisampled, use a compressed or
  /// depth/stencil format, and be used as a render attachment.
  texture2d,

  /// Specifies a texture that has a width, height, and depth.
  texture3d;

  int get nativeIndex => index + 1;
}
