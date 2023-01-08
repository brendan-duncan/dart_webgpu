enum ErrorFilter {
  outOfMemory,
  validation,
  internal;

  int get nativeIndex => index + 1;
}
