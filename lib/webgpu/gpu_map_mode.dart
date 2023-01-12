class GpuMapMode {
  static const read = GpuMapMode(0x1);
  static const write = GpuMapMode(0x2);
  static const readWrite = GpuMapMode(0x3);

  final int value;
  const GpuMapMode(this.value);

  GpuMapMode operator |(GpuMapMode other) => GpuMapMode(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is GpuMapMode && value == other.value ||
      other is int && value == other;

  @override
  int get hashCode => value;
}
