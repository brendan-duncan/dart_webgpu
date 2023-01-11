import '_binding_layout_type.dart';
import '_map_util.dart';
import 'texture_sample_type.dart';
import 'texture_view_dimension.dart';

/// Texture entry for a BindGroupLayoutEntry
class TextureBindingLayout extends BindingLayoutType {
  /// Indicates the type required for texture views bound to this binding.
  final TextureSampleType sampleType;

  /// Indicates the required dimension for texture views bound to this binding.
  final TextureViewDimension viewDimension;

  /// Indicates whether or not texture views bound to this binding must be
  /// multisampled.
  final bool multisampled;

  const TextureBindingLayout(
      {this.sampleType = TextureSampleType.float,
      this.viewDimension = TextureViewDimension.textureView2d,
      this.multisampled = false});

  factory TextureBindingLayout.fromMap(Map<String, Object> map) {
    final sampleType = getMapValue<TextureSampleType>(
        map['sampleType'], TextureSampleType.float);
    final viewDimension = getMapValue<TextureViewDimension>(
        map['viewDimension'], TextureViewDimension.textureView2d);
    final multisampled = getMapValue<bool>(map['multisampled'], false);
    return TextureBindingLayout(
        sampleType: sampleType,
        viewDimension: viewDimension,
        multisampled: multisampled);
  }
}
