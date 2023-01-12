enum GpuMappedState {
  unmapped,
  pending,
  mapped;

  int get nativeIndex => index + 1;
}
