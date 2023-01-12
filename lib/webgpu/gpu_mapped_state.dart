enum GPUMappedState {
  unmapped,
  pending,
  mapped;

  static GPUMappedState fromString(String s) {
    switch (s) {
      case 'unmapped':
        return GPUMappedState.mapped;
      case 'pending':
        return GPUMappedState.pending;
      case 'mapped':
        return GPUMappedState.mapped;
    }
    throw Exception('Invalid value for GPUMappedState');
  }

  int get nativeIndex => index + 1;
}
