import '_binding_layout_type.dart';
import '_map_util.dart';
import 'gpu_texture_sample_type.dart';
import 'gpu_texture_view_dimension.dart';

/// Texture entry for a BindGroupLayoutEntry
class GpuTextureBindingLayout extends GpuBindingLayoutType {
  /// Indicates the type required for texture views bound to this binding.
  final GpuTextureSampleType sampleType;

  /// Indicates the required dimension for texture views bound to this binding.
  final GpuTextureViewDimension viewDimension;

  /// Indicates whether or not texture views bound to this binding must be
  /// multisampled.
  final bool multisampled;

  const GpuTextureBindingLayout(
      {this.sampleType = GpuTextureSampleType.float,
      this.viewDimension = GpuTextureViewDimension.textureView2d,
      this.multisampled = false});

  factory GpuTextureBindingLayout.fromMap(Map<String, Object> map) {
    final sampleType = getMapValue<GpuTextureSampleType>(
        map['sampleType'], GpuTextureSampleType.float);
    final viewDimension = getMapValue<GpuTextureViewDimension>(
        map['viewDimension'], GpuTextureViewDimension.textureView2d);
    final multisampled = getMapValue<bool>(map['multisampled'], false);
    return GpuTextureBindingLayout(
        sampleType: sampleType,
        viewDimension: viewDimension,
        multisampled: multisampled);
  }
}
