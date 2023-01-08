/// Defines the primitive type draw calls made with a RenderPipeline will use.
enum PrimitiveTopology {
  pointList,
  lineList,
  lineStrip,
  triangleList,
  triangleStrip;

  int get nativeIndex => index + 1;
}
