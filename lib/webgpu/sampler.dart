import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'address_mode.dart';
import 'compare_function.dart';
import 'device.dart';
import 'filter_mode.dart';
import 'wgpu_object.dart';

class Sampler extends WGpuObjectBase<wgpu.WGpuSampler> {
  final Device device;
  final AddressMode addressModeU;
  final AddressMode addressModeV;
  final AddressMode addressModeW;
  final FilterMode magFilter;
  final FilterMode minFilter;
  final FilterMode mipmapFilter;
  final num lodMinClamp;
  final num lodMaxClamp;
  final CompareFunction compare;
  final int maxAnisotropy;

  Sampler(this.device,
      {this.addressModeU = AddressMode.clampToEdge,
      this.addressModeV = AddressMode.clampToEdge,
      this.addressModeW = AddressMode.clampToEdge,
      this.magFilter = FilterMode.nearest,
      this.minFilter = FilterMode.nearest,
      this.mipmapFilter = FilterMode.nearest,
      this.lodMinClamp = 0,
      this.lodMaxClamp = 32,
      this.compare = CompareFunction.always,
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
    final o = libwebgpu.wgpu_device_create_sampler(object, d);
    setObject(o);
    calloc.free(o);
  }
}
