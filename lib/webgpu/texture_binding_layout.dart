import '_binding_layout_type.dart';
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
}
