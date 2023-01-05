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

class Queue extends WGpuObject<wgpu.WGpuQueue> {
  Device device;

  Queue(this.device, wgpu.WGpuQueue o)
      : super(o, device);

  void submit(CommandBuffer commandBuffer) {
    libwebgpu.wgpu_queue_submit_one(object, commandBuffer.object);
  }

  void writeBuffer(Buffer buffer, int bufferOffset, Uint8List data) {
    // Uint8List is managed data and we need to convert it to native data.
    final length = min(data.length, buffer.length);
    final p = malloc<Uint8>(length)
    ..asTypedList(length)
    .setAll(0, data);

    libwebgpu.wgpu_queue_write_buffer(
        object, buffer.object, bufferOffset, p.cast(), length);

    malloc.free(p);
  }

  /*void writeTexture(Texture texture, Uint8List data, Extent3D size) {
  }

  void copyExternalImageToTexture(ExternalImage source, Texture texture,
      Extent3D size) {
  }*/

  @override
  String toString() => 'Queue';
}