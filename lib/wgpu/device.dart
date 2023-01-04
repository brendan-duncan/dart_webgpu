import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'features.dart';
import 'limits.dart';

class Device implements Finalizable {
  wgpu.WGpuDevice device;
  late final Limits limits;
  late final Features features;

  Device(this.device) {
    webgpu.attachFinalizer(this, device.cast());
    features = Features(library.wgpu_adapter_or_device_get_features(device));
    _getLimits();
  }

  void destroy() {
    webgpu.detachFinalizer(this);
    webgpu.destroyObject(device);
    device = nullptr;
  }

  void _getLimits() {
    final l = calloc<wgpu.WGpuSupportedLimits>();
    library.wgpu_adapter_or_device_get_limits(device, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);
  }
}
