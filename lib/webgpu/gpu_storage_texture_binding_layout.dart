import '_binding_layout_type.dart';
import '_map_util.dart';
import 'gpu_storage_texture_access.dart';
import 'gpu_texture_format.dart';
import 'gpu_texture_view_dimension.dart';

class GPUStorageTextureBindingLayout extends GpuBindingLayoutType {
  /// Indicates whether TextureViews bound to this binding will be bound for
  /// readOnly or writeOnly access.
  final GPUStorageTextureAccess access;

  /// The required format of TextureViews bound to this binding.
  final GPUTextureFormat format;

  /// Indicates the required dimension for TextureViews bound to this binding.
  final GPUTextureViewDimension viewDimension;

  const GPUStorageTextureBindingLayout(
      {this.access = GPUStorageTextureAccess.writeOnly,
      required this.format,
      this.viewDimension = GPUTextureViewDimension.textureView2d});

  factory GPUStorageTextureBindingLayout.fromMap(Map<String, Object> map) {
    final access =
        getMapValue(map['access'], GPUStorageTextureAccess.writeOnly);
    final format = getMapValueRequired<GPUTextureFormat>(map['format']);
    final viewDimension = getMapValue(
        map['viewDimension'], GPUTextureViewDimension.textureView2d);
    return GPUStorageTextureBindingLayout(
        format: format, access: access, viewDimension: viewDimension);
  }
}
