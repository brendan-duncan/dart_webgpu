import 'texture.dart';
import 'texture_aspect.dart';

/// In an image copy operation, a ImageCopyTexture defines a [Texture] and,
/// together with the copySize, the sub-region of the texture (spanning one or
/// more contiguous texture subresources at the same mip-map level).
class ImageCopyTexture {
  /// Texture to copy to/from.
  final Texture texture;

  /// Mip-map level of the texture to copy to/from.
  final int mipLevel;

  /// Defines the origin of the copy - the minimum corner of the texture
  /// sub-region to copy to/from. Together with copySize, defines the full copy
  /// sub-region. This is a list of 1-3 ints, corresponding to the x, y, and
  /// z origin values.
  final List<int> origin;

  /// Defines which aspects of the texture to copy to/from.
  final TextureAspect aspect;

  const ImageCopyTexture(
      {required this.texture,
      this.mipLevel = 0,
      this.origin = const [0, 0, 0],
      this.aspect = TextureAspect.all});
}
