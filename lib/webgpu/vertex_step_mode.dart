/// The step mode configures how an address for vertex buffer data is computed,
/// based on the current vertex or instance index
enum VertexStepMode {
  /// The address is advanced by arrayStride for each vertex, and reset between
  /// instances.
  vertex,
  /// The address is advanced by arrayStride for each instance.
  instance;

  int get nativeIndex => index + 1;
}
