import '_map_util.dart';
import 'gpu_buffer_binding_layout.dart';
import 'gpu_external_texture_binding_layout.dart';
import 'gpu_sampler_binding_layout.dart';
import 'gpu_shader_stage.dart';
import 'gpu_storage_texture_binding_layout.dart';
import 'gpu_texture_binding_layout.dart';

/// Describes a single shader resource binding to be included in a
/// BindGroupLayout.
class GPUBindGroupLayoutEntry {
  /// A unique identifier for a resource binding within the BindGroupLayout,
  /// corresponding to a BindGroupEntry.binding and a @binding attribute in the
  /// ShaderModule.
  final int binding;

  /// A bitset of the members of ShaderStage. Each set bit indicates that a
  /// BindGroupLayoutEntry's resource will be accessible from the associated
  /// shader stage.
  final GPUShaderStage visibility;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is BufferBinding.
  final GPUBufferBindingLayout? buffer;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is Sampler.
  final GPUSamplerBindingLayout? sampler;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is TextureView.
  final GPUTextureBindingLayout? texture;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is TextureView.
  final GPUStorageTextureBindingLayout? storageTexture;

  /// When not null, indicates the binding resource type for this
  /// BindGroupLayoutEntry is ExternalTexture.
  final GPUExternalTextureBindingLayout? externalTexture;

  const GPUBindGroupLayoutEntry(
      {required this.binding,
      required this.visibility,
      this.buffer,
      this.sampler,
      this.texture,
      this.storageTexture,
      this.externalTexture});

  factory GPUBindGroupLayoutEntry.fromMap(Map<String, Object> map) {
    final binding = getMapValueRequired<int>(map['binding']);
    final visibility = getMapValueRequired<GPUShaderStage>(map['visibility']);
    final buffer = getMapObjectNullable<GPUBufferBindingLayout>(map['buffer']);
    final sampler =
        getMapObjectNullable<GPUSamplerBindingLayout>(map['sampler']);
    final texture =
        getMapObjectNullable<GPUTextureBindingLayout>(map['texture']);
    final storageTexture = getMapObjectNullable<GPUStorageTextureBindingLayout>(
        map['storageTexture']);
    final externalTexture =
        getMapObjectNullable<GPUExternalTextureBindingLayout>(
            map['externalTexture']);

    return GPUBindGroupLayoutEntry(
        binding: binding,
        visibility: visibility,
        buffer: buffer,
        sampler: sampler,
        texture: texture,
        storageTexture: storageTexture,
        externalTexture: externalTexture);
  }
}
