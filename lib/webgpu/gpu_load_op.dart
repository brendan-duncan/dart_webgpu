enum GpuLoadOp {
  /// Loads the existing value for this attachment into the render pass.
  load,

  /// Loads a clear value for this attachment into the render pass.
  clear;

  int get nativeIndex => index;
}
