enum GPULoadOp {
  undefined,

  /// Loads the existing value for this attachment into the render pass.
  load,

  /// Loads a clear value for this attachment into the render pass.
  clear;

  static GPULoadOp fromString(String s) {
    switch (s) {
      case 'load':
        return GPULoadOp.load;
      case 'clear':
        return GPULoadOp.clear;
    }
    throw Exception('Invalid value for GPULoadOp');
  }

  int get nativeIndex => index;
}
