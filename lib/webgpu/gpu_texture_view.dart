import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_object.dart';
import 'gpu_texture.dart';
import 'gpu_texture_aspect.dart';
import 'gpu_texture_format.dart';
import 'gpu_texture_view_dimension.dart';

/// A view onto some subset of the texture subresources defined by a particular
/// [GPUTexture].
class GPUTextureView extends GPUObjectBase<wgpu.WGpuTextureView> {
  /// The format of the texture view. Must be either the format of the texture
  /// or one of the viewFormats specified during its creation.
  late final GPUTextureFormat format;

  /// The dimension to view the texture as.
  final GPUTextureViewDimension dimension;

  /// Which aspect(s) of the texture are accessible to the texture view.
  final GPUTextureAspect aspect;

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

  GPUTextureView.native(wgpu.WGpuTextureView o)
      : format = GPUTextureFormat.bgra8unorm,
        dimension = GPUTextureViewDimension.textureView2d,
        aspect = GPUTextureAspect.all,
        baseMipLevel = 0,
        mipLevelCount = 1,
        baseArrayLayer = 0,
        arrayLayerCount = 1 {
    setObject(o);
  }

  GPUTextureView(GPUTexture texture,
      {required this.dimension,
      GPUTextureFormat? format,
      this.aspect = GPUTextureAspect.all,
      this.baseMipLevel = 0,
      this.mipLevelCount = 1,
      this.baseArrayLayer = 0,
      this.arrayLayerCount = 1}) {
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
