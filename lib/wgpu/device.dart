import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'adapter.dart';
import 'buffer.dart';
import 'buffer_usage.dart';
import 'features.dart';
import 'limits.dart';
import 'queue.dart';
import 'shader_module.dart';
import 'wgpu_object.dart';

class Device extends WGpuObject<wgpu.WGpuDevice> {
  Adapter adapter;
  late final Limits limits;
  late final Features features;
  late final Queue queue;

  Device(this.adapter, Pointer device) : super(device) {
    adapter.addDependent(this);
    features = Features(libwebgpu.wgpu_adapter_or_device_get_features(object));
    queue = Queue(this, libwebgpu.wgpu_device_get_queue(object));
    _getLimits();
  }

  void _getLimits() {
    final l = calloc<wgpu.WGpuSupportedLimits>();
    libwebgpu.wgpu_adapter_or_device_get_limits(object, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);
  }

  ShaderModule createShaderModule(
      {required String code
        /*, Map<String, wgpu.WGpuPipelineLayout>? hints*/}) =>
    ShaderModule(this, code: code);//, hints: hints);

  Buffer createBuffer(
      {required int length,
      required BufferUsage usage,
      bool mappedAtCreation = false}) =>
    Buffer(this,
        length: length, usage: usage, mappedAtCreation: mappedAtCreation);
}
