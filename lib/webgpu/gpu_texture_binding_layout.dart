import '_binding_layout_type.dart';
import '_map_util.dart';
import 'gpu_texture_sample_type.dart';
import 'gpu_texture_view_dimension.dart';

/// Texture entry for a BindGroupLayoutEntry
class GPUTextureBindingLayout extends GpuBindingLayoutType {
  /// Indicates the type required for texture views bound to this binding.
  final GPUTextureSampleType sampleType;

  /// Indicates the required dimension for texture views bound to this binding.
  final GPUTextureViewDimension viewDimension;

  /// Indicates whether or not texture views bound to this binding must be
  /// multisampled.
  final bool multisampled;

  const GPUTextureBindingLayout(
      {this.sampleType = GPUTextureSampleType.float,
      this.viewDimension = GPUTextureViewDimension.textureView2d,
      this.multisampled = false});

  factory GPUTextureBindingLayout.fromMap(Map<String, Object> map) {
    final sampleType = mapValue<GPUTextureSampleType>(
        map['sampleType'], GPUTextureSampleType.float);
    final viewDimension = mapValue<GPUTextureViewDimension>(
        map['viewDimension'], GPUTextureViewDimension.textureView2d);
    final multisampled = mapValue<bool>(map['multisampled'], false);
    return GPUTextureBindingLayout(
        sampleType: sampleType,
        viewDimension: viewDimension,
        multisampled: multisampled);
  }
}
