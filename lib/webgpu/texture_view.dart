import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'texture.dart';
import 'texture_aspect.dart';
import 'texture_format.dart';
import 'texture_view_dimension.dart';
import 'wgpu_object.dart';

/// A view onto some subset of the texture subresources defined by a particular
/// [Texture].
class TextureView extends WGpuObjectBase<wgpu.WGpuTextureView> {
  /// The [Texture] into which this is a view.
  final Texture texture;
  /// The format of the texture view. Must be either the format of the texture
  /// or one of the viewFormats specified during its creation.
  late final TextureFormat format;
  /// The dimension to view the texture as.
  final TextureViewDimension dimension;
  /// Which aspect(s) of the texture are accessible to the texture view.
  final TextureAspect aspect;
  /// The first (most detailed) mipmap level accessible to the texture view.
  final int baseMipLevel;
  /// How many mipmap levels, starting with baseMipLevel, are accessible to the
  /// texture view.
  final int mipLevelCount;
  /// The index of the first array layer accessible to the texture view.
  final int baseArrayLayer;
  /// How many array layers, starting with baseArrayLayer, are accessible to the
  /// texture view.
  final int arrayLayerCount;

  TextureView(this.texture,
      {required this.dimension,
      TextureFormat? format,
      this.aspect = TextureAspect.all,
      this.baseMipLevel = 0,
      this.mipLevelCount = 0,
      this.baseArrayLayer = 0,
      this.arrayLayerCount = 0}) {
    texture.addDependent(this);
    this.format = format ?? texture.format;
    final d = calloc<wgpu.WGpuTextureViewDescriptor>();
    d.ref.format = this.format.nativeIndex;
    d.ref.dimension = dimension.nativeIndex;
    d.ref.aspect = aspect.nativeIndex;
    d.ref.baseMipLevel = baseMipLevel;
    d.ref.mipLevelCount = mipLevelCount;
    d.ref.baseArrayLayer = baseArrayLayer;
    d.ref.arrayLayerCount = arrayLayerCount;
    final o = libwebgpu.wgpu_texture_create_view(texture.object, d);
    setObject(o);
    calloc.free(d);
  }
}
