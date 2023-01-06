/// Flags which describe what shader stages a corresponding BindGroupLayoutEntry
/// will be visible to.
class ShaderState {
  /// The bind group entry will be accessible to vertex shaders.
  static const vertex = ShaderState(0x1);

  /// The bind group entry will be accessible to fragment shaders.
  static const fragment = ShaderState(0x2);

  /// The bind group entry will be accessible to compute shaders.
  static const compute = ShaderState(0x4);

  final int value;
  const ShaderState(this.value);

  ShaderState operator |(ShaderState other) => ShaderState(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is ShaderState && value == other.value ||
      other is int && other == value;

  @override
  int get hashCode => value;
}
