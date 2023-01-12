import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_address_mode.dart';
import 'gpu_compare_function.dart';
import 'gpu_device.dart';
import 'gpu_filter_mode.dart';
import 'gpu_object.dart';

class GPUSampler extends GPUObjectBase<wgpu.WGpuSampler> {
  final GPUDevice device;
  final GPUAddressMode addressModeU;
  final GPUAddressMode addressModeV;
  final GPUAddressMode addressModeW;
  final GPUFilterMode magFilter;
  final GPUFilterMode minFilter;
  final GPUFilterMode mipmapFilter;
  final num lodMinClamp;
  final num lodMaxClamp;
  final GPUCompareFunction compare;
  final int maxAnisotropy;

  GPUSampler(this.device,
      {this.addressModeU = GPUAddressMode.clampToEdge,
      this.addressModeV = GPUAddressMode.clampToEdge,
      this.addressModeW = GPUAddressMode.clampToEdge,
      this.magFilter = GPUFilterMode.nearest,
      this.minFilter = GPUFilterMode.nearest,
      this.mipmapFilter = GPUFilterMode.nearest,
      this.lodMinClamp = 0,
      this.lodMaxClamp = 32,
      this.compare = GPUCompareFunction.undefined,
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
