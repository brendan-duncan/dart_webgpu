enum GpuErrorFilter {
  outOfMemory,
  validation,
  internal;

  int get nativeIndex => index + 1;
}
