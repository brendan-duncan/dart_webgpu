import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';
import 'gpu_query_type.dart';

class GPUQuerySet extends GPUObjectBase<wgpu.WGpuQuerySet> {
  /// The type of queries managed by QuerySet.
  final GPUQueryType type;

  /// The number of queries managed by QuerySet.
  final int count;

  GPUQuerySet(GPUDevice device, {required this.type, required this.count}) {
    device.addDependent(this);
    final d = calloc<wgpu.WGpuQuerySetDescriptor>();
    d.ref.type = type.nativeIndex;
    d.ref.count = count;
    final o = libwebgpu.wgpu_device_create_query_set(device.object, d);
    setObject(o);
    calloc.free(d);
  }
}
