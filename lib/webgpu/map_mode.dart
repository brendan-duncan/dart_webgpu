class MapMode {
  static const read = MapMode(0x1);
  static const write = MapMode(0x2);
  static const readWrite = MapMode(0x3);

  final int value;
  const MapMode(this.value);

  MapMode operator |(MapMode other) => MapMode(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is MapMode && value == other.value ||
      other is int && value == other;

  @override
  int get hashCode => value;
}
