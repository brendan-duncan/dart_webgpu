enum GPUErrorType {
  none,
  outOfMemory,
  validation,
  unknown;

  static GPUErrorType fromString(String s) {
    switch (s) {
      case 'none':
        return GPUErrorType.none;
      case 'out-of-memory':
        return GPUErrorType.outOfMemory;
      case 'validation':
        return GPUErrorType.validation;
      case 'unknown':
        return GPUErrorType.unknown;
    }
    throw Exception('Invalid value for GPUErrorType');
  }

  int get nativeIndex => index;
}
