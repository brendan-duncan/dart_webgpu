/// The TextureUsage flags determine how a GPUTexture may be used after its
/// creation.
class GPUTextureUsage {
  /// The texture can be used as the source of a copy operation.
  /// (Examples: as the source argument of a copyTextureToTexture() or
  /// copyTextureToBuffer() call.)
  static const copySrc = GPUTextureUsage(0x01);

  /// The texture can be used as the destination of a copy or write operation.
  /// (Examples: as the destination argument of a copyTextureToTexture() or
  /// copyBufferToTexture() call, or as the target of a writeTexture() call.)
  static const copyDst = GPUTextureUsage(0x02);

  /// The texture can be bound for use as a sampled texture in a shader
  /// (Example: as a bind group entry for a TextureBindingLayout.)
  static const textureBinding = GPUTextureUsage(0x04);

  /// The texture can be bound for use as a storage texture in a shader
  /// (Example: as a bind group entry for a StorageTextureBindingLayout.)
  static const storageBinding = GPUTextureUsage(0x08);

  /// The texture can be used as a color or depth/stencil attachment in a render
  /// pass. (Example: as a RenderPassColorAttachment.view or
  /// RenderPassDepthStencilAttachment.view.)
  static const renderAttachment = GPUTextureUsage(0x10);

  final int value;
  const GPUTextureUsage(this.value);

  GPUTextureUsage operator |(GPUTextureUsage other) =>
      GPUTextureUsage(value | other.value);

  @override
  bool operator ==(Object other) =>
      (other is GPUTextureUsage && other.value == value) ||
      (other is int && other == value);

  @override
  int get hashCode => value;
}
