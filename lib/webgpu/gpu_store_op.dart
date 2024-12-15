enum GPUStoreOp {
  undefined,

  /// Stores the resulting value of the render pass for this attachment.
  store,

  /// Discards the resulting value of the render pass for this attachment.
  discard;

  static GPUStoreOp fromString(String s) {
    switch (s) {
      case 'store':
        return GPUStoreOp.store;
      case 'discard':
        return GPUStoreOp.discard;
    }
    throw Exception('Invalid value for GPUStoreOp');
  }

  int get nativeIndex => index;
}
