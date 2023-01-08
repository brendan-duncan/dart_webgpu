/// Defines which polygons are considered front-facing by a RenderPipeline.
enum FrontFace {
  ccw,
  cw;

  int get nativeIndex => index + 1;
}
