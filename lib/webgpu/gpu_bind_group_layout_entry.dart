import '_map_util.dart';
import 'gpu_buffer_binding_layout.dart';
import 'gpu_external_texture_binding_layout.dart';
import 'gpu_sampler_binding_layout.dart';
import 'gpu_shader_stage.dart';
import 'gpu_storage_texture_binding_layout.dart';
import 'gpu_texture_binding_layout.dart';

/// Describes a single shader resource binding to be included in a
/// BindGroupLayout.
class GpuBindGroupLayoutEntry {
  /// A unique identifier for a resource binding within the BindGroupLayout,
  /// corresponding to a BindGroupEntry.binding and a @binding attribute in the
  /// ShaderModule.
  final int binding;

  /// A bitset of the members of ShaderStage. Each set bit indicates that a
  /// BindGroupLayoutEntry's resource will be accessible from the associated
  /// shader stage.
  final GpuShaderStage visibility;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is BufferBinding.
  final GpuBufferBindingLayout? buffer;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is Sampler.
  final GpuSamplerBindingLayout? sampler;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is TextureView.
  final GpuTextureBindingLayout? texture;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is TextureView.
  final GpuStorageTextureBindingLayout? storageTexture;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is ExternalTexture.
  final GpuExternalTextureBindingLayout? externalTexture;

  const GpuBindGroupLayoutEntry(
      {required this.binding,
      required this.visibility,
      this.buffer,
      this.sampler,
      this.texture,
      this.storageTexture,
      this.externalTexture});

  factory GpuBindGroupLayoutEntry.fromMap(Map<String, Object> map) {
    final binding = getMapValueRequired<int>(map['binding']);
    final visibility = getMapValueRequired<GpuShaderStage>(map['visibility']);
    final buffer = getMapObjectNullable<GpuBufferBindingLayout>(map['buffer']);
    final sampler =
        getMapObjectNullable<GpuSamplerBindingLayout>(map['sampler']);
    final texture =
        getMapObjectNullable<GpuTextureBindingLayout>(map['texture']);
    final storageTexture = getMapObjectNullable<GpuStorageTextureBindingLayout>(
        map['storageTexture']);
    final externalTexture =
        getMapObjectNullable<GpuExternalTextureBindingLayout>(
            map['externalTexture']);

    return GpuBindGroupLayoutEntry(
        binding: binding,
        visibility: visibility,
        buffer: buffer,
        sampler: sampler,
        texture: texture,
        storageTexture: storageTexture,
        externalTexture: externalTexture);
  }
}
