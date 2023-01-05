import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'adapter.dart';
import 'features.dart';
import 'limits.dart';
import 'shader_module_descriptor.dart';
import 'shader_module.dart';
import 'wgpu_object.dart';

class Device extends WGpuObject<wgpu.WGpuDevice> {
  Adapter adapter;
  late final Limits limits;
  late final Features features;

  Device(this.adapter, Pointer device)
    : super(device) {
    adapter.addDependent(this);
    features = Features(library.wgpu_adapter_or_device_get_features(object));
    _getLimits();
  }

  void _getLimits() {
    final l = calloc<wgpu.WGpuSupportedLimits>();
    library.wgpu_adapter_or_device_get_limits(object, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);
  }

  ShaderModule createShaderModule(ShaderModuleDescriptor descriptor) {
    return ShaderModule(this, descriptor);
  }
}
