class GPUMapMode {
  static const read = GPUMapMode(0x1);
  static const write = GPUMapMode(0x2);
  static const readWrite = GPUMapMode(0x3);

  final int value;
  const GPUMapMode(this.value);

  GPUMapMode operator |(GPUMapMode other) => GPUMapMode(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is GPUMapMode && value == other.value ||
      other is int && value == other;

  @override
  int get hashCode => value;
}
