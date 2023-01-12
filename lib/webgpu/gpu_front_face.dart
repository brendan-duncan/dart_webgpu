/// Defines which polygons are considered front-facing by a RenderPipeline.
enum GPUFrontFace {
  ccw,
  cw;

  static GPUFrontFace fromString(String s) {
    switch (s) {
      case 'ccw':
        return GPUFrontFace.ccw;
      case 'cw':
        return GPUFrontFace.cw;
    }
    throw Exception('Invalid value for GPUFrontFace');
  }

  int get nativeIndex => index + 1;
}
