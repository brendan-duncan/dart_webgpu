import '_binding_layout_type.dart';
import 'storage_texture_access.dart';
import 'texture_format.dart';
import 'texture_view_dimension.dart';

class StorageTextureBindingLayout extends BindingLayoutType {
  /// Indicates whether TextureViews bound to this binding will be bound for
  /// readOnly or writeOnly access.
  final StorageTextureAccess access;
  /// The required format of TextureViews bound to this binding.
  final TextureFormat format;
  /// Indicates the required dimension for TextureViews bound to this binding.
  final TextureViewDimension viewDimension;

  const StorageTextureBindingLayout({
    this.access = StorageTextureAccess.writeOnly,
    required this.format,
    this.viewDimension = TextureViewDimension.textureView2d});
}
