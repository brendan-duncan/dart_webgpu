enum ErrorType {
  none,
  outOfMemory,
  validation,
  unknown;

  int get nativeIndex => index;
}
