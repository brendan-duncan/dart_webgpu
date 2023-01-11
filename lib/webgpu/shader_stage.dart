/// Flags which describe what shader stages a corresponding BindGroupLayoutEntry
/// will be visible to.
class ShaderStage {
  /// The bind group entry will be accessible to vertex shaders.
  static const vertex = ShaderStage(0x1);

  /// The bind group entry will be accessible to fragment shaders.
  static const fragment = ShaderStage(0x2);

  /// The bind group entry will be accessible to compute shaders.
  static const compute = ShaderStage(0x4);

  final int value;
  const ShaderStage(this.value);

  ShaderStage operator |(ShaderStage other) => ShaderStage(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is ShaderStage && value == other.value ||
      other is int && other == value;

  @override
  int get hashCode => value;
}
