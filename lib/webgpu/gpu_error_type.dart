enum GpuErrorType {
  none,
  outOfMemory,
  validation,
  unknown;

  int get nativeIndex => index;
}
