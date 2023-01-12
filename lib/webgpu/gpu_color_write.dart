class GPUColorWrite {
  static const red = GPUColorWrite(0x1);
  static const green = GPUColorWrite(0x2);
  static const blue = GPUColorWrite(0x4);
  static const alpha = GPUColorWrite(0x8);
  static const all = GPUColorWrite(0xf);

  final int value;
  const GPUColorWrite(this.value);

  GPUColorWrite operator |(GPUColorWrite other) =>
      GPUColorWrite(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is GPUColorWrite && value == other.value ||
      other is int && value == other;

  @override
  int get hashCode => value;
}
