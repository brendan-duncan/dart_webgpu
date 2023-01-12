/// Determines how a Buffer may be used after its creation.
class GPUBufferUsage {
  /// The buffer can be mapped for reading. (Example: calling mapAsync() with
  /// MapMode.read). May only be combined with copyDst.
  static const mapRead = GPUBufferUsage(0x001);

  /// The buffer can be mapped for writing. (Example: calling mapAsync() with
  /// MapMode.write). May only be combined with copySrc.
  static const mapWrite = GPUBufferUsage(0x0002);

  /// The buffer can be used as the source of a copy operation. (Examples: as
  /// the source argument of a copyBufferToBuffer() or copyBufferToTexture()
  /// call.)
  static const copySrc = GPUBufferUsage(0x0004);

  /// The buffer can be used as the destination of a copy or write operation.
  /// (Examples: as the destination argument of a copyBufferToBuffer() or
  /// copyTextureToBuffer() call, or as the target of a writeBuffer() call.)
  static const copyDst = GPUBufferUsage(0x0008);

  /// The buffer can be used as an index buffer. (Example: passed to
  /// setIndexBuffer().)
  static const index = GPUBufferUsage(0x0010);

  /// The buffer can be used as a vertex buffer. (Example: passed to
  /// setVertexBuffer().)
  static const vertex = GPUBufferUsage(0x0020);

  /// The buffer can be used as a uniform buffer. (Example: as a bind group
  /// entry for a BufferBindingLayout with a buffer.type of "uniform".)
  static const uniform = GPUBufferUsage(0x0040);

  /// The buffer can be used as a storage buffer. (Example: as a bind group
  /// entry for a GPUBufferBindingLayout with a buffer.type of "storage" or
  /// "read-only-storage".)
  static const storage = GPUBufferUsage(0x0080);

  /// The buffer can be used as to store indirect command arguments.
  /// (Examples: as the indirectBuffer argument of a drawIndirect() or
  /// dispatchWorkgroupsIndirect() call.)
  static const indirect = GPUBufferUsage(0x0100);

  /// The buffer can be used to capture query results. (Example: as the
  /// destination argument of a resolveQuerySet() call.)
  static const queryResolve = GPUBufferUsage(0x0200);

  final int value;
  const GPUBufferUsage([this.value = 0]);

  bool supports(GPUBufferUsage features) => (value & features.value) != 0;

  @override
  bool operator ==(Object other) =>
      other is GPUBufferUsage && value == other.value ||
      other is int && value == other;

  @override
  int get hashCode => value;

  GPUBufferUsage operator |(GPUBufferUsage rhs) =>
      GPUBufferUsage(value | rhs.value);

  GPUBufferUsage remove(GPUBufferUsage f) => GPUBufferUsage(value & ~f.value);

  /// Certain combination of usage flags are not allowed. Returns true if
  /// the usage flags are valid.
  bool get isValid {
    if (value == 0) {
      return false;
    }

    // mapRead can only be combined with copyDst.
    if (supports(mapRead) &&
        (value != mapRead.value && value != (mapRead.value | copyDst.value))) {
      return false;
    }

    // mapWrit an only be combined with copySrc
    if (supports(mapWrite) &&
        (value != mapWrite.value &&
            value != (mapWrite.value | copySrc.value))) {
      return false;
    }

    return true;
  }

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
