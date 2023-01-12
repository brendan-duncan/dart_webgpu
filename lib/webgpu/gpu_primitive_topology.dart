/// Defines the primitive type draw calls made with a RenderPipeline will use.
enum GpuPrimitiveTopology {
  pointList,
  lineList,
  lineStrip,
  triangleList,
  triangleStrip;

  int get nativeIndex => index + 1;
}
