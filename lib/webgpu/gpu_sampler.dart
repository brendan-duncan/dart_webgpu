import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_address_mode.dart';
import 'gpu_compare_function.dart';
import 'gpu_device.dart';
import 'gpu_filter_mode.dart';
import 'gpu_object.dart';

class GpuSampler extends GpuObjectBase<wgpu.WGpuSampler> {
  final GpuDevice device;
  final GpuAddressMode addressModeU;
  final GpuAddressMode addressModeV;
  final GpuAddressMode addressModeW;
  final GpuFilterMode magFilter;
  final GpuFilterMode minFilter;
  final GpuFilterMode mipmapFilter;
  final num lodMinClamp;
  final num lodMaxClamp;
  final GpuCompareFunction compare;
  final int maxAnisotropy;

  GpuSampler(this.device,
      {this.addressModeU = GpuAddressMode.clampToEdge,
      this.addressModeV = GpuAddressMode.clampToEdge,
      this.addressModeW = GpuAddressMode.clampToEdge,
      this.magFilter = GpuFilterMode.nearest,
      this.minFilter = GpuFilterMode.nearest,
      this.mipmapFilter = GpuFilterMode.nearest,
      this.lodMinClamp = 0,
      this.lodMaxClamp = 32,
      this.compare = GpuCompareFunction.undefined,
      this.maxAnisotropy = 1}) {
    device.addDependent(this);
    final d = calloc<wgpu.WGpuSamplerDescriptor>();
    d.ref.addressModeU = addressModeU.nativeIndex;
    d.ref.addressModeV = addressModeV.nativeIndex;
    d.ref.addressModeW = addressModeW.nativeIndex;
    d.ref.magFilter = magFilter.nativeIndex;
    d.ref.minFilter = minFilter.nativeIndex;
    d.ref.mipmapFilter = mipmapFilter.nativeIndex;
    d.ref.lodMinClamp = lodMinClamp.toDouble();
    d.ref.lodMaxClamp = lodMaxClamp.toDouble();
    d.ref.compare = compare.nativeIndex;
    d.ref.maxAnisotropy = maxAnisotropy;
    final o = libwebgpu.wgpu_device_create_sampler(device.object, d);
    setObject(o);
    calloc.free(d);
  }
}
