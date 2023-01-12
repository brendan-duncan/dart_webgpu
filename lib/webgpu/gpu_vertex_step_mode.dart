/// The step mode configures how an address for vertex buffer data is computed,
/// based on the current vertex or instance index
enum GPUVertexStepMode {
  /// The address is advanced by arrayStride for each vertex, and reset between
  /// instances.
  vertex,

  /// The address is advanced by arrayStride for each instance.
  instance;

  static GPUVertexStepMode fromString(String s) {
    switch (s) {
      case 'vertex':
        return GPUVertexStepMode.vertex;
      case 'instance':
        return GPUVertexStepMode.instance;
    }
    throw Exception('Invalid value for GPUVertexStepMode');
  }

  int get nativeIndex => index + 1;
}
