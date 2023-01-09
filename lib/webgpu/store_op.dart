enum StoreOp {
  /// Stores the resulting value of the render pass for this attachment.
  store,

  /// Discards the resulting value of the render pass for this attachment.
  discard;

  int get nativeIndex => index + 1;
}
