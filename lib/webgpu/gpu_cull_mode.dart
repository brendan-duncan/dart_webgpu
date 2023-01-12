/// Defines which polygons will be culled by draw calls made with a
/// RenderPipeline.
enum GPUCullMode {
  /// No polygons are discarded.
  none,

  /// Front-facing polygons are discarded.
  front,

  /// Back-facing polygons are discarded.
  back;

  static GPUCullMode fromString(String s) {
    switch (s) {
      case "none":
        return GPUCullMode.none;
      case "front":
        return GPUCullMode.front;
      case "back":
        return GPUCullMode.back;
    }
    throw Exception('Invalid value for GPUCullMode');
  }

  int get nativeIndex => index + 1;
}
