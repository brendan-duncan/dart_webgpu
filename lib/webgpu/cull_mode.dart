/// Defines which polygons will be culled by draw calls made with a
/// RenderPipeline.
enum CullMode {
  /// No polygons are discarded.
  none,
  /// Front-facing polygons are discarded.
  front,
  /// Back-facing polygons are discarded.
  back;

  int get nativeIndex => index + 1;
}
