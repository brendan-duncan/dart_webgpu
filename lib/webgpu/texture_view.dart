import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'texture.dart';
import 'texture_aspect.dart';
import 'texture_format.dart';
import 'texture_view_dimension.dart';
import 'wgpu_object.dart';

class TextureView extends WGpuObject<wgpu.WGpuTextureView> {
  final Texture texture;
  late final TextureFormat format;
  final TextureViewDimension dimension;
  final TextureAspect aspect;
  final int baseMipLevel;
  final int mipLevelCount;
  final int baseArrayLayer;
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
    d.ref.format = this.format.index;
    d.ref.dimension = dimension.index;
    d.ref.aspect = aspect.index;
    d.ref.baseMipLevel = baseMipLevel;
    d.ref.mipLevelCount = mipLevelCount;
    d.ref.baseArrayLayer = baseArrayLayer;
    d.ref.arrayLayerCount = arrayLayerCount;
    final o = libwebgpu.wgpu_texture_create_view(texture.object, d);
    setObject(o);
    calloc.free(d);
  }
}
