/// Defines the primitive type draw calls made with a RenderPipeline will use.
enum GPUPrimitiveTopology {
  pointList,
  lineList,
  lineStrip,
  triangleList,
  triangleStrip;

  static GPUPrimitiveTopology fromString(String s) {
    switch (s) {
      case 'point-list':
        return GPUPrimitiveTopology.pointList;
      case 'line-list':
        return GPUPrimitiveTopology.lineList;
      case 'line-strip':
        return GPUPrimitiveTopology.lineStrip;
      case 'triangle-list':
        return GPUPrimitiveTopology.triangleList;
      case 'triangle-strip':
        return GPUPrimitiveTopology.triangleStrip;
    }
    throw Exception('Invalid value for GPUPrimitiveTopology');
  }

  int get nativeIndex => index + 1;
}
