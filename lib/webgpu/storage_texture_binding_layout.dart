import '_binding_layout_type.dart';
import '_map_util.dart';
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

  const StorageTextureBindingLayout(
      {this.access = StorageTextureAccess.writeOnly,
      required this.format,
      this.viewDimension = TextureViewDimension.textureView2d});

  factory StorageTextureBindingLayout.fromMap(Map<String, Object> map) {
    final access = getMapValue(map['access'], StorageTextureAccess.writeOnly);
    final format = getMapValueRequired<TextureFormat>(map['format']);
    final viewDimension =
        getMapValue(map['viewDimension'], TextureViewDimension.textureView2d);
    return StorageTextureBindingLayout(
        format: format, access: access, viewDimension: viewDimension);
  }
}
