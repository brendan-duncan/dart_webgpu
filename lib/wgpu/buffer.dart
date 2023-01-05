import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'device.dart';
import 'buffer_descriptor.dart';
import 'wgpu_object.dart';

class Buffer extends WGpuObject<wgpu.WGpuBuffer> {
  final Device device;

  Buffer(this.device, BufferDescriptor descriptor) {
    final p = calloc<wgpu.WGpuBufferDescriptor>();

    p.ref.size = descriptor.size;
    p.ref.usage = descriptor.usage.value;
    p.ref.mappedAtCreation = descriptor.mappedAtCreation ? 1 : 0;

    final obj = library.wgpu_device_create_buffer(device.object, p);
    setObject(obj);
    device.addDependent(this);

    calloc.free(p);
  }
}
