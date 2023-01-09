/// Defines how a Buffer will be used by a pipeline.
enum BufferBindingType {
  /// The buffer will be used as a uniform buffer.
  uniform,

  /// The buffer will be used as a storage buffer.
  storage,

  /// The buffer will be used as a read-only storage buffer.
  readOnlyStorage;

  int get nativeIndex => index + 1;
}
