/// Defines which polygons are considered front-facing by a RenderPipeline.
enum GpuFrontFace {
  ccw,
  cw;

  int get nativeIndex => index + 1;
}
