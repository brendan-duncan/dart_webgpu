/// The dimension to view the texture as.
enum TextureViewDimension {
  undefined,

  /// The texture is viewed as a 1-dimensional image.
  textureView1d,

  /// The texture is viewed as a single 2-dimensional image.
  textureView2d,

  /// The texture view is viewed as an array of 2-dimensional images.
  textureView2dArray,

  /// The texture is viewed as a cubemap. The view has 6 array layers,
  /// corresponding to the [+X, -X, +Y, -Y, +Z, -Z] faces of the cube. Sampling
  /// is done seamlessly across the faces of the cubemap.
  textureViewCube,

  /// The texture is viewed as a packed array of n cubemaps, each with 6 array
  /// layers corresponding to the [+X, -X, +Y, -Y, +Z, -Z] faces of the cube.
  /// Sampling is done seamlessly across the faces of the cubemaps.
  textureViewCubeArray,

  /// The texture is viewed as a 3-dimensional image.
  textureView3d
}
