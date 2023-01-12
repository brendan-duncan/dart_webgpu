/// Flags which describe what shader stages a corresponding BindGroupLayoutEntry
/// will be visible to.
class GpuShaderStage {
  /// The bind group entry will be accessible to vertex shaders.
  static const vertex = GpuShaderStage(0x1);

  /// The bind group entry will be accessible to fragment shaders.
  static const fragment = GpuShaderStage(0x2);

  /// The bind group entry will be accessible to compute shaders.
  static const compute = GpuShaderStage(0x4);

  final int value;
  const GpuShaderStage(this.value);

  GpuShaderStage operator |(GpuShaderStage other) =>
      GpuShaderStage(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is GpuShaderStage && value == other.value ||
      other is int && other == value;

  @override
  int get hashCode => value;
}
