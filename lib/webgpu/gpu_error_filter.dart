enum GPUErrorFilter {
  outOfMemory,
  validation,
  internal;

  static GPUErrorFilter fromString(String s) {
    switch (s) {
      case 'validation':
        return GPUErrorFilter.validation;
      case 'out-of-memory':
        return GPUErrorFilter.outOfMemory;
      case 'internal':
        return GPUErrorFilter.internal;
    }
    throw Exception('Invalid value for GPUErrorFilter');
  }

  int get nativeIndex => index + 1;
}
