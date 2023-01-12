enum GPUStencilOperation {
  keep,
  zero,
  replace,
  invert,
  incrementClamp,
  decrementClamp,
  incrementWrap,
  decrementWrap;

  static GPUStencilOperation fromString(String s) {
    switch (s) {
      case 'keep':
        return GPUStencilOperation.keep;
      case 'zero':
        return GPUStencilOperation.zero;
      case 'replace':
        return GPUStencilOperation.replace;
      case 'invert':
        return GPUStencilOperation.invert;
      case 'increment-clamp':
        return GPUStencilOperation.incrementClamp;
      case 'decrement-clamp':
        return GPUStencilOperation.decrementClamp;
      case 'increment-wrap':
        return GPUStencilOperation.incrementWrap;
      case 'decrement-wrap':
        return GPUStencilOperation.decrementWrap;
    }
    throw Exception('Invalid value for GPUStencilOperation');
  }

  int get nativeIndex => index + 1;
}
