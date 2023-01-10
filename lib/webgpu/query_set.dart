import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'device.dart';
import 'query_type.dart';
import 'wgpu_object.dart';

class QuerySet extends WGpuObjectBase<wgpu.WGpuQuerySet> {
  /// The [Device] that created this QuerySet.
  final Device device;

  /// The type of queries managed by QuerySet.
  final QueryType type;

  /// The number of queries managed by QuerySet.
  final int count;

  QuerySet(this.device, {required this.type, required this.count}) {
    device.addDependent(this);
    final d = calloc<wgpu.WGpuQuerySetDescriptor>();
    d.ref.type = type.nativeIndex;
    d.ref.count = count;
    final o = libwebgpu.wgpu_device_create_query_set(device.object, d);
    setObject(o);
    calloc.free(d);
  }
}
