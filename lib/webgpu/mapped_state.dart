enum MappedState {
  unmapped,
  pending,
  mapped;

  int get nativeIndex => index + 1;
}
