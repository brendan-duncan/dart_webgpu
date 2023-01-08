enum ErrorType {
  outOfMemory,
  validation,
  unknown;

  int get nativeIndex => index + 1;
}
