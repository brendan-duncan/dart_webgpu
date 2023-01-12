import '_map_util.dart';
import 'gpu_texture.dart';
import 'gpu_texture_aspect.dart';

/// In an image copy operation, a ImageCopyTexture defines a [GpuTexture] and,
/// together with the copySize, the sub-region of the texture (spanning one or
/// more contiguous texture subresources at the same mip-map level).
class GpuImageCopyTexture {
  /// Texture to copy to/from.
  final GpuTexture texture;

  /// Mip-map level of the texture to copy to/from.
  final int mipLevel;

  /// Defines the origin of the copy - the minimum corner of the texture
  /// sub-region to copy to/from. Together with copySize, defines the full copy
  /// sub-region. This is a list of 1-3 ints, corresponding to the x, y, and
  /// z origin values.
  final List<int> origin;

  /// Defines which aspects of the texture to copy to/from.
  final GpuTextureAspect aspect;

  const GpuImageCopyTexture(
      {required this.texture,
      this.mipLevel = 0,
      this.origin = const [0, 0, 0],
      this.aspect = GpuTextureAspect.all});

  factory GpuImageCopyTexture.fromMap(Map<String, Object> map) {
    final texture = getMapValueRequired<GpuTexture>(map['texture']);
    final mipLevel = getMapValue<int>(map['mipLevel'], 0);
    final origin = getMapValue<List<int>>(map['origin'], [0, 0, 0]);
    final aspect =
        getMapValue<GpuTextureAspect>(map['aspect'], GpuTextureAspect.all);
    return GpuImageCopyTexture(
        texture: texture, mipLevel: mipLevel, origin: origin, aspect: aspect);
  }
}
