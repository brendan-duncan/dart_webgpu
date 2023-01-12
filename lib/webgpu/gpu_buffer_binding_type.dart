/// Defines how a Buffer will be used by a pipeline.
enum GPUBufferBindingType {
  /// The buffer will be used as a uniform buffer.
  uniform,

  /// The buffer will be used as a storage buffer.
  storage,

  /// The buffer will be used as a read-only storage buffer.
  readOnlyStorage;

  static GPUBufferBindingType fromString(String s) {
    switch (s) {
      case "uniform":
        return GPUBufferBindingType.uniform;
      case "storage":
        return GPUBufferBindingType.storage;
      case "read-only-storage":
        return GPUBufferBindingType.readOnlyStorage;
    }
    throw Exception('Invalid value for GPUBufferBindingType');
  }

  int get nativeIndex => index + 1;
}
