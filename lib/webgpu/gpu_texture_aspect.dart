/// Each texture resource has an aspect. Color textures have just one aspect:
/// color. Depth-or-stencil format textures may have multiple aspects:
/// a depth aspect, a stencil aspect, or both, and may be used in special ways,
/// such as in depthStencilAttachment and in "depth" bindings.
enum GpuTextureAspect {
  /// All available aspects of the TextureFormat will be accessible to the
  /// TextureView. For color formats the color aspect will be accessible.
  /// For combined depth-stencil formats both the depth and stencil aspects will
  /// be accessible. Depth-or-stencil formats with a single aspect will only
  /// make that aspect accessible.
  all,

  /// Only the stencil aspect of a depth-or-stencil format format will be
  /// accessible to the TextureView.
  stencilOnly,

  /// Only the depth aspect of a depth-or-stencil format format will be
  /// accessible to the TextureView.
  depthOnly;

  int get nativeIndex => index + 1;
}
