class GpuFeatures {
  static const depthClipControl = GpuFeatures(0x01);
  static const depth32FloatStencil8 = GpuFeatures(0x02);
  static const textureCompressionBC = GpuFeatures(0x04);
  static const textureCompressionEtc2 = GpuFeatures(0x08);
  static const textureCompressionAstc = GpuFeatures(0x10);
  static const timestampQuery = GpuFeatures(0x20);
  static const indirectFirstInstance = GpuFeatures(0x40);
  static const shaderF16 = GpuFeatures(0x80);
  static const bgra8UnormStorage = GpuFeatures(0x100);
  static const rg11b10UfloatRenderable = GpuFeatures(0x200);

  final int value;
  const GpuFeatures([this.value = 0]);

  bool supports(GpuFeatures features) => (value & features.value) != 0;

  GpuFeatures operator |(GpuFeatures rhs) => GpuFeatures(value | rhs.value);

  GpuFeatures remove(GpuFeatures f) => GpuFeatures(value & ~f.value);

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
