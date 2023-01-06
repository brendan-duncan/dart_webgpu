/// Defines how a Buffer will be used by a pipeline.
enum BufferBindingType {
  _invalid,

  /// The buffer will be used as a uniform buffer.
  uniform,

  /// The buffer will be used as a storage buffer.
  storage,

  /// The buffer will be used as a read-only storage buffer.
  readOnlyStorage
}
