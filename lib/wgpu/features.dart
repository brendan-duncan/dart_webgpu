class Features {
  static const depthClipControl = Features(0x01);
  static const depth32FloatStencil8 = Features(0x02);
  static const textureCompressionBC = Features(0x04);
  static const textureCompressionEtc2 = Features(0x08);
  static const textureCompressionAstc = Features(0x10);
  static const timestampQuery = Features(0x20);
  static const indirectFirstInstance = Features(0x40);
  static const shaderF16 = Features(0x80);
  static const bgra8UnormStorage = Features(0x100);
  static const rg11b10UfloatRenderable = Features(0x200);

  final int value;
  const Features([this.value = 0]);

  bool supports(Features features) => (value & features.value) != 0;

  Features operator |(Features rhs) => Features(value | rhs.value);

  Features remove(Features f) {
    return Features(value & ~f.value);
  }

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
