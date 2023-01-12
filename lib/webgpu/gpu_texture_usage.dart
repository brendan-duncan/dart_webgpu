/// The TextureUsage flags determine how a GPUTexture may be used after its
/// creation.
class GpuTextureUsage {
  /// The texture can be used as the source of a copy operation.
  /// (Examples: as the source argument of a copyTextureToTexture() or
  /// copyTextureToBuffer() call.)
  static const copySrc = GpuTextureUsage(0x01);

  /// The texture can be used as the destination of a copy or write operation.
  /// (Examples: as the destination argument of a copyTextureToTexture() or
  /// copyBufferToTexture() call, or as the target of a writeTexture() call.)
  static const copyDst = GpuTextureUsage(0x02);

  /// The texture can be bound for use as a sampled texture in a shader
  /// (Example: as a bind group entry for a TextureBindingLayout.)
  static const textureBinding = GpuTextureUsage(0x04);

  /// The texture can be bound for use as a storage texture in a shader
  /// (Example: as a bind group entry for a StorageTextureBindingLayout.)
  static const storageBinding = GpuTextureUsage(0x08);

  /// The texture can be used as a color or depth/stencil attachment in a render
  /// pass. (Example: as a RenderPassColorAttachment.view or
  /// RenderPassDepthStencilAttachment.view.)
  static const renderAttachment = GpuTextureUsage(0x10);

  final int value;
  const GpuTextureUsage(this.value);

  GpuTextureUsage operator |(GpuTextureUsage other) =>
      GpuTextureUsage(value | other.value);

  @override
  bool operator ==(Object other) =>
      (other is GpuTextureUsage && other.value == value) ||
      (other is int && other == value);

  @override
  int get hashCode => value;
}
