class GPUFeatures {
  static const depthClipControl = GPUFeatures(0x01);
  static const depth32FloatStencil8 = GPUFeatures(0x02);
  static const textureCompressionBC = GPUFeatures(0x04);
  static const textureCompressionEtc2 = GPUFeatures(0x08);
  static const textureCompressionAstc = GPUFeatures(0x10);
  static const timestampQuery = GPUFeatures(0x20);
  static const indirectFirstInstance = GPUFeatures(0x40);
  static const shaderF16 = GPUFeatures(0x80);
  static const bgra8UnormStorage = GPUFeatures(0x100);
  static const rg11b10UfloatRenderable = GPUFeatures(0x200);

  final int value;
  const GPUFeatures([this.value = 0]);

  bool supports(GPUFeatures features) => (value & features.value) != 0;

  GPUFeatures operator |(GPUFeatures rhs) => GPUFeatures(value | rhs.value);

  GPUFeatures remove(GPUFeatures f) => GPUFeatures(value & ~f.value);

  @override
  String toString() {
    final s = StringBuffer();
    if (supports(depthClipControl)) {
      s.writeln('depth-clip-control');
    }
    if (supports(depth32FloatStencil8)) {
      s.writeln('depth32float-stencil8');
    }
    if (supports(textureCompressionBC)) {
      s.writeln('texture-compression-bc');
    }
    if (supports(textureCompressionEtc2)) {
      s.writeln('texture-compression-etc2');
    }
    if (supports(textureCompressionAstc)) {
      s.writeln('texture-compression-astc');
    }
    if (supports(timestampQuery)) {
      s.writeln('timestamp-query');
    }
    if (supports(indirectFirstInstance)) {
      s.writeln('indirect-first-instance');
    }
    if (supports(shaderF16)) {
      s.writeln('shader-f16');
    }
    if (supports(bgra8UnormStorage)) {
      s.writeln('bgra8unorm-storage');
    }
    if (supports(rg11b10UfloatRenderable)) {
      s.writeln('rg11b10ufloat-renderable');
    }
    return s.toString();
  }
}
