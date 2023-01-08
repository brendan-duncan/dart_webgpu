class ColorWrite {
  static const red = ColorWrite(0x1);
  static const green = ColorWrite(0x2);
  static const blue = ColorWrite(0x4);
  static const alpha = ColorWrite(0x8);
  static const all = ColorWrite(0xf);

  final int value;
  const ColorWrite(this.value);

  ColorWrite operator |(ColorWrite other) => ColorWrite(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is ColorWrite && value == other.value ||
      other is int && value == other;

  @override
  int get hashCode => value;
}
