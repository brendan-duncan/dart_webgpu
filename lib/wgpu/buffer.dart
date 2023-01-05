import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'buffer_mapped_state.dart';
import 'buffer_range.dart';
import 'buffer_usage.dart';
import 'device.dart';
import 'wgpu_object.dart';

class Buffer extends WGpuObject<wgpu.WGpuBuffer> {
  final Device device;
  late BufferMappedState mappedState;
  late final int length;
  late final BufferUsage usage;

  Buffer(this.device,
      {required this.length,
      required this.usage,
      bool mappedAtCreation = false}) {
    final p = calloc<wgpu.WGpuBufferDescriptor>();

    p.ref.size = length;
    p.ref.usage = usage.value;
    p.ref.mappedAtCreation = mappedAtCreation ? 1 : 0;

    final obj = libwebgpu.wgpu_device_create_buffer(device.object, p);
    setObject(obj);
    device.addDependent(this);

    if (obj != nullptr && mappedAtCreation) {
      mappedState = BufferMappedState.mapped;
    } else {
      mappedState = BufferMappedState.unmapped;
    }

    calloc.free(p);
  }

  BufferRange getMappedRange(int startOffset, int size) {
    if (mappedState != BufferMappedState.mapped) {
      throw Exception('Cannot call getMappedRange on an unmapped buffer.');
    }
    return BufferRange(
        this,
        libwebgpu.wgpu_buffer_get_mapped_range(object, startOffset, size),
        size);
  }

  @override
  String toString() => 'Buffer(length: $length, usage: $usage)';
}
