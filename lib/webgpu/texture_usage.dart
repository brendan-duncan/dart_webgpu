/// The TextureUsage flags determine how a GPUTexture may be used after its
/// creation.
class TextureUsage {
  /// The texture can be used as the source of a copy operation.
  /// (Examples: as the source argument of a copyTextureToTexture() or
  /// copyTextureToBuffer() call.)
  static const copySrc = TextureUsage(0x01);

  /// The texture can be used as the destination of a copy or write operation.
  /// (Examples: as the destination argument of a copyTextureToTexture() or
  /// copyBufferToTexture() call, or as the target of a writeTexture() call.)
  static const copyDst = TextureUsage(0x02);

  /// The texture can be bound for use as a sampled texture in a shader
  /// (Example: as a bind group entry for a TextureBindingLayout.)
  static const textureBinding = TextureUsage(0x04);

  /// The texture can be bound for use as a storage texture in a shader
  /// (Example: as a bind group entry for a StorageTextureBindingLayout.)
  static const storageBinding = TextureUsage(0x08);

  /// The texture can be used as a color or depth/stencil attachment in a render
  /// pass. (Example: as a RenderPassColorAttachment.view or
  /// RenderPassDepthStencilAttachment.view.)
  static const renderAttachment = TextureUsage(0x10);

  final int value;
  const TextureUsage(this.value);

  TextureUsage operator |(TextureUsage other) =>
      TextureUsage(value | other.value);

  @override
  bool operator ==(Object other) =>
      (other is TextureUsage && other.value == value) ||
      (other is int && other == value);

  @override
  int get hashCode => value;
}
