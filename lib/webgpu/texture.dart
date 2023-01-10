import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'device.dart';
import 'texture_aspect.dart';
import 'texture_dimension.dart';
import 'texture_format.dart';
import 'texture_usage.dart';
import 'texture_view.dart';
import 'texture_view_dimension.dart';
import 'wgpu_object.dart';

/// One texture consists of one or more texture subresources, each uniquely
/// identified by a mipmap level and, for 2d textures only, array layer and
/// aspect.
///
/// A texture subresource is a subresource: each can be used in different
/// internal usages within a single usage scope.
///
/// Each subresource in a mipmap level is approximately half the size, in each
/// spatial dimension, of the corresponding resource in the lesser level.
/// The subresource in level 0 has the dimensions of the texture itself.
/// These are typically used to represent levels of detail of a texture.
/// Sampler and WGSL provide facilities for selecting and interpolating between
/// levels of detail, explicitly or automatically.
///
/// A "2d" texture may be an array of array layers. Each subresource in a layer
/// is the same size as the corresponding resources in other layers. For non-2d
/// textures, all subresources have an array layer index of 0.
///
/// Each subresource has an aspect. Color textures have just one aspect: color.
/// Depth-or-stencil format textures may have multiple aspects: a depth aspect,
/// a stencil aspect, or both, and may be used in special ways, such as in
/// depthStencilAttachment and in "depth" bindings.
///
/// A "3d" texture may have multiple slices, each being the two-dimensional
/// image at a particular z value in the texture. Slices are not separate
/// subresources.
class Texture extends WGpuObjectBase<wgpu.WGpuTexture> {
  final Device device;

  /// The width of this Texture.
  final int width;

  /// The height of this Texture.
  final int height;

  /// The depth or layer count of this Texture.
  final int depthOrArrayLayers;

  /// The format of this Texture.
  final TextureFormat format;

  /// The allowed usages for this Texture.
  final TextureUsage usage;

  /// The number of mip levels of this Texture.
  final int mipLevelCount;

  /// The number of sample count of this Texture.
  final int sampleCount;

  /// The dimension of the set of texel for each of this Texture's subresources.
  final TextureDimension dimension;

  /// Specifies what view format values will be allowed when calling
  /// createView() on this texture (in addition to the texture’s actual format).
  final List<TextureFormat>? viewFormats;

  Texture(this.device,
      {required this.width,
      this.height = 1,
      this.depthOrArrayLayers = 1,
      required this.format,
      required this.usage,
      this.mipLevelCount = 1,
      this.sampleCount = 1,
      this.dimension = TextureDimension.texture2d,
      this.viewFormats}) {
    device.addDependent(this);
    final d = calloc<wgpu.WGpuTextureDescriptor>();
    d.ref.width = width;
    d.ref.height = height;
    d.ref.depthOrArrayLayers = depthOrArrayLayers;
    d.ref.format = format.nativeIndex;
    d.ref.usage = usage.value;
    d.ref.mipLevelCount = mipLevelCount;
    d.ref.sampleCount = sampleCount;
    d.ref.dimension = dimension.nativeIndex;
    //d.ref.viewFormats =
    final o = libwebgpu.wgpu_device_create_texture(device.object, d);
    setObject(o);
    calloc.free(d);
  }

  /// Create a [TextureView].
  TextureView createView(
      {TextureFormat? format,
      TextureViewDimension? dimension,
      TextureAspect aspect = TextureAspect.all,
      int baseMipLevel = 0,
      int mipLevelCount = 1,
      int baseArrayLayer = 0,
      int arrayLayerCount = 1}) {
    format ??= this.format;
    dimension ??= this.dimension == TextureDimension.texture1d
        ? TextureViewDimension.textureView1d
        : this.dimension == TextureDimension.texture2d
            ? depthOrArrayLayers > 1
                ? TextureViewDimension.textureView2dArray
                : TextureViewDimension.textureView2d
            : TextureViewDimension.textureView3d;

    return TextureView(this,
        dimension: dimension,
        aspect: aspect,
        format: format,
        baseArrayLayer: baseArrayLayer,
        arrayLayerCount: arrayLayerCount,
        baseMipLevel: baseMipLevel,
        mipLevelCount: mipLevelCount);
  }
}
