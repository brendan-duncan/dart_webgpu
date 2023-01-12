/// Flags which describe what shader stages a corresponding BindGroupLayoutEntry
/// will be visible to.
class GPUShaderStage {
  /// The bind group entry will be accessible to vertex shaders.
  static const vertex = GPUShaderStage(0x1);

  /// The bind group entry will be accessible to fragment shaders.
  static const fragment = GPUShaderStage(0x2);

  /// The bind group entry will be accessible to compute shaders.
  static const compute = GPUShaderStage(0x4);

  final int value;
  const GPUShaderStage(this.value);

  GPUShaderStage operator |(GPUShaderStage other) =>
      GPUShaderStage(value | other.value);

  @override
  bool operator ==(Object other) =>
      other is GPUShaderStage && value == other.value ||
      other is int && other == value;

  @override
  int get hashCode => value;
}
