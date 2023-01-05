class BufferUsage {
  static const mapRead = BufferUsage(0x001);
  static const mapWrite = BufferUsage(0x0002);
  static const copySrc = BufferUsage(0x0004);
  static const copyDst = BufferUsage(0x0008);
  static const index = BufferUsage(0x0010);
  static const vertex = BufferUsage(0x0020);
  static const uniform = BufferUsage(0x0040);
  static const storage = BufferUsage(0x0080);
  static const indirect = BufferUsage(0x0100);
  static const queryResolve = BufferUsage(0x0200);

  final int value;
  const BufferUsage([this.value = 0]);

  bool supports(BufferUsage features) => (value & features.value) != 0;

  BufferUsage operator |(BufferUsage rhs) => BufferUsage(value | rhs.value);

  BufferUsage remove(BufferUsage f) => BufferUsage(value & ~f.value);

  @override
  String toString() {
    final s = StringBuffer();
    void add(String f) {
      if (s.isNotEmpty) {
        s.write(',');
      }
      s.write(f);
    }

    if (supports(mapRead)) {
      add('mapRead');
    }
    if (supports(mapWrite)) {
      add('mapWrite');
    }
    if (supports(copySrc)) {
      add('copySrc');
    }
    if (supports(copyDst)) {
      add('copyDst');
    }
    if (supports(index)) {
      add('index');
    }
    if (supports(vertex)) {
      add('vertex');
    }
    if (supports(uniform)) {
      add('uniform');
    }
    if (supports(storage)) {
      add('storage');
    }
    if (supports(indirect)) {
      add('indirect');
    }
    if (supports(queryResolve)) {
      add('queryResolve');
    }
    return s.toString();
  }
}
