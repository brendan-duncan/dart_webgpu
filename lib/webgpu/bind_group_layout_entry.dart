import '_map_util.dart';
import 'buffer_binding_layout.dart';
import 'external_texture_binding_layout.dart';
import 'sampler_binding_layout.dart';
import 'shader_stage.dart';
import 'storage_texture_binding_layout.dart';
import 'texture_binding_layout.dart';

/// Describes a single shader resource binding to be included in a
/// BindGroupLayout.
class BindGroupLayoutEntry {
  /// A unique identifier for a resource binding within the BindGroupLayout,
  /// corresponding to a BindGroupEntry.binding and a @binding attribute in the
  /// ShaderModule.
  final int binding;

  /// A bitset of the members of ShaderStage. Each set bit indicates that a
  /// BindGroupLayoutEntry's resource will be accessible from the associated
  /// shader stage.
  final ShaderStage visibility;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is BufferBinding.
  final BufferBindingLayout? buffer;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is Sampler.
  final SamplerBindingLayout? sampler;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is TextureView.
  final TextureBindingLayout? texture;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is TextureView.
  final StorageTextureBindingLayout? storageTexture;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is ExternalTexture.
  final ExternalTextureBindingLayout? externalTexture;

  const BindGroupLayoutEntry(
      {required this.binding,
      required this.visibility,
      this.buffer,
      this.sampler,
      this.texture,
      this.storageTexture,
      this.externalTexture});

  factory BindGroupLayoutEntry.fromMap(Map<String, Object> map) {
    final binding = getMapValueRequired<int>(map['binding']);
    final visibility = getMapValueRequired<ShaderStage>(map['visibility']);
    final buffer = getMapObjectNullable<BufferBindingLayout>(map['buffer']);
    final sampler = getMapObjectNullable<SamplerBindingLayout>(map['sampler']);
    final texture = getMapObjectNullable<TextureBindingLayout>(map['texture']);
    final storageTexture = getMapObjectNullable<StorageTextureBindingLayout>(
        map['storageTexture']);
    final externalTexture = getMapObjectNullable<ExternalTextureBindingLayout>(
        map['externalTexture']);

    return BindGroupLayoutEntry(
        binding: binding,
        visibility: visibility,
        buffer: buffer,
        sampler: sampler,
        texture: texture,
        storageTexture: storageTexture,
        externalTexture: externalTexture);
  }
}
