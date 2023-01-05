class BufferUsageFlags {
  static const mapRead = BufferUsageFlags(0x001);
  static const mapWrite = BufferUsageFlags(0x0002);
  static const copySrc = BufferUsageFlags(0x0004);
  static const copyDst = BufferUsageFlags(0x0008);
  static const index = BufferUsageFlags(0x0010);
  static const vertex = BufferUsageFlags(0x0020);
  static const uniform = BufferUsageFlags(0x0040);
  static const storage = BufferUsageFlags(0x0080);
  static const indirect = BufferUsageFlags(0x0100);
  static const queryResolve = BufferUsageFlags(0x0200);

  final int value;
  const BufferUsageFlags([this.value = 0]);

  bool supports(BufferUsageFlags features) => (value & features.value) != 0;

  BufferUsageFlags operator |(BufferUsageFlags rhs) =>
      BufferUsageFlags(value | rhs.value);

  BufferUsageFlags remove(BufferUsageFlags f) {
    return BufferUsageFlags(value & ~f.value);
  }

  String toString() {
    final s = StringBuffer();
    if (supports(mapRead)) {
      s.write('mapRead,');
    }
    if (supports(mapWrite)) {
      s.write('mapWrite,');
    }
    if (supports(copySrc)) {
      s.write('copySrc,');
    }
    if (supports(copyDst)) {
      s.write('copyDst,');
    }
    if (supports(index)) {
      s.write('index,');
    }
    if (supports(vertex)) {
      s.write('vertex,');
    }
    if (supports(uniform)) {
      s.write('uniform,');
    }
    if (supports(storage)) {
      s.write('storage,');
    }
    if (supports(indirect)) {
      s.write('indirect,');
    }
    if (supports(queryResolve)) {
      s.write('queryResolve,');
    }
    return s.toString();
  }
}
