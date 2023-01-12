import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';
import 'gpu_query_type.dart';

class GpuQuerySet extends GpuObjectBase<wgpu.WGpuQuerySet> {
  /// The [Device] that created this QuerySet.
  final GpuDevice device;

  /// The type of queries managed by QuerySet.
  final GpuQueryType type;

  /// The number of queries managed by QuerySet.
  final int count;

  GpuQuerySet(this.device, {required this.type, required this.count}) {
    device.addDependent(this);
    final d = calloc<wgpu.WGpuQuerySetDescriptor>();
    d.ref.type = type.nativeIndex;
    d.ref.count = count;
    final o = libwebgpu.wgpu_device_create_query_set(device.object, d);
    setObject(o);
    calloc.free(d);
  }
}
