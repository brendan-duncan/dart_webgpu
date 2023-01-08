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

class Texture extends WGpuObject<wgpu.WGpuTexture> {
  final Device device;
  final int width;
  final int height;
  final int depthOrArrayLayers;
  final TextureFormat format;
  final TextureUsage usage;
  final int mipLevelCount;
  final int sampleCount;
  final TextureDimension dimension;
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
    d.ref.format = format.index;
    d.ref.usage = usage.value;
    d.ref.mipLevelCount = mipLevelCount;
    d.ref.sampleCount = sampleCount;
    d.ref.dimension = dimension.index;
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
      int mipLevelCount = 0,
      int baseArrayLayer = 0,
      int arrayLayerCount = 0}) {
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
