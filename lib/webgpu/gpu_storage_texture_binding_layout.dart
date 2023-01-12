import '_binding_layout_type.dart';
import '_map_util.dart';
import 'gpu_storage_texture_access.dart';
import 'gpu_texture_format.dart';
import 'gpu_texture_view_dimension.dart';

class GpuStorageTextureBindingLayout extends GpuBindingLayoutType {
  /// Indicates whether TextureViews bound to this binding will be bound for
  /// readOnly or writeOnly access.
  final GpuStorageTextureAccess access;

  /// The required format of TextureViews bound to this binding.
  final GpuTextureFormat format;

  /// Indicates the required dimension for TextureViews bound to this binding.
  final GpuTextureViewDimension viewDimension;

  const GpuStorageTextureBindingLayout(
      {this.access = GpuStorageTextureAccess.writeOnly,
      required this.format,
      this.viewDimension = GpuTextureViewDimension.textureView2d});

  factory GpuStorageTextureBindingLayout.fromMap(Map<String, Object> map) {
    final access =
        getMapValue(map['access'], GpuStorageTextureAccess.writeOnly);
    final format = getMapValueRequired<GpuTextureFormat>(map['format']);
    final viewDimension = getMapValue(
        map['viewDimension'], GpuTextureViewDimension.textureView2d);
    return GpuStorageTextureBindingLayout(
        format: format, access: access, viewDimension: viewDimension);
  }
}
