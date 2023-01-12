class GpuColorWrite {
  static const red = GpuColorWrite(0x1);
  static const green = GpuColorWrite(0x2);
  static const blue = GpuColorWrite(0x4);
  static const alpha = GpuColorWrite(0x8);
  static const all = GpuColorWrite(0xf);

  final int value;
  const GpuColorWrite(this.value);

  GpuColorWrite operator |(GpuColorWrite other) =>
      GpuColorWrite(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is GpuColorWrite && value == other.value ||
      other is int && value == other;

  @override
  int get hashCode => value;
}
