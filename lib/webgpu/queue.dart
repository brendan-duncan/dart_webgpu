import 'dart:ffi';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'buffer.dart';
import 'command_buffer.dart';
import 'device.dart';
import 'wgpu_object.dart';

class Queue extends WGpuObjectBase<wgpu.WGpuQueue> {
  final Device device;

  Queue(this.device, wgpu.WGpuQueue o) : super(o, device);

  void submit(Object commandBufferOrList) {
    if (commandBufferOrList is CommandBuffer) {
      libwebgpu.wgpu_queue_submit_one(object, commandBufferOrList.object);
    } else if (commandBufferOrList is List<CommandBuffer>) {
      for (final cb in commandBufferOrList) {
        libwebgpu.wgpu_queue_submit_one(object, cb.object);
      }
    } else {
      throw Exception('Invalid CommandBuffer for Queue.submit.');
    }
  }

  void writeBuffer(Buffer buffer, int bufferOffset, Uint8List data) {
    // Uint8List is managed data and we need to convert it to native data.
    final size = min(data.length, buffer.size);
    final p = malloc<Uint8>(size)..asTypedList(size).setAll(0, data);

    libwebgpu.wgpu_queue_write_buffer(
        object, buffer.object, bufferOffset, p.cast(), size);

    malloc.free(p);
  }

  @override
  String toString() => 'Queue';
}
