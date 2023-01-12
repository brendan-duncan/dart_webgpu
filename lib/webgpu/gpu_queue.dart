import 'dart:ffi';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_buffer.dart';
import 'gpu_command_buffer.dart';
import 'gpu_device.dart';
import 'gpu_image_copy_texture.dart';
import 'gpu_image_data_layout.dart';
import 'gpu_object.dart';

class GPUQueue extends GPUObjectBase<wgpu.WGpuQueue> {
  final GPUDevice device;

  GPUQueue(this.device, wgpu.WGpuQueue o) : super(o, device);

  /// Schedules the execution of the command buffers by the GPU on this queue.
  /// Submitted command buffers cannot be used again.
  void submit([Object? commandBufferOrList]) {
    // Submitting an empty command-buffer can be used to flush the pending queue
    // commands.
    if (commandBufferOrList == null) {
      libwebgpu.wgpu_queue_submit_multiple(object, nullptr, 0);
    } else if (commandBufferOrList is GPUCommandBuffer) {
      libwebgpu.wgpu_queue_submit_one(object, commandBufferOrList.object);
      commandBufferOrList.destroy();
    } else if (commandBufferOrList is List<GPUCommandBuffer>) {
      for (final cb in commandBufferOrList) {
        libwebgpu.wgpu_queue_submit_one(object, cb.object);
        cb.destroy();
      }
    } else {
      throw Exception('Invalid CommandBuffer for Queue.submit.');
    }
  }

  /// Issues a write operation of the provided data into a Buffer.
  void writeBuffer(GPUBuffer buffer, int bufferOffset, Uint8List data) {
    // Uint8List is managed data and we need to convert it to native data.
    final size = min(data.length, buffer.size);
    final p = malloc<Uint8>(size)..asTypedList(size).setAll(0, data);

    libwebgpu.wgpu_queue_write_buffer(
        object, buffer.object, bufferOffset, p.cast(), size);

    malloc.free(p);
  }

  /// Issues a write operation of the provided data into a Texture.
  void writeTexture(
      {required Object destination,
      required Uint8List data,
      required Object dataLayout,
      required int width,
      int height = 1,
      int depthOrArrayLayers = 1}) {
    if (destination is Map<String, Object>) {
      destination = GPUImageCopyTexture.fromMap(destination);
    }
    if (destination is! GPUImageCopyTexture) {
      throw Exception('Invalid ImageCopyTexture for writeTexture');
    }
    final d = calloc<wgpu.WGpuImageCopyTexture>();
    d.ref.texture = destination.texture.object;
    d.ref.mipLevel = destination.mipLevel;
    final originLen = destination.origin.length;
    d.ref.origin.x = originLen > 0 ? destination.origin[0] : 0;
    d.ref.origin.y = originLen > 0 ? destination.origin[0] : 0;
    d.ref.origin.z = originLen > 0 ? destination.origin[0] : 0;
    d.ref.aspect = destination.aspect.nativeIndex;

    // Uint8List is managed data and we need to convert it to native data.
    final size = data.length;
    final p = malloc<Uint8>(size)..asTypedList(size).setAll(0, data);

    if (dataLayout is Map<String, Object>) {
      dataLayout = GPUImageDataLayout.fromMap(dataLayout);
    }
    if (dataLayout is! GPUImageDataLayout) {
      throw Exception('Invalid data for writeTexture datalayout');
    }

    libwebgpu.wgpu_queue_write_texture(
        object,
        d,
        p.cast(),
        dataLayout.bytesPerRow,
        dataLayout.rowsPerImage,
        width,
        height,
        depthOrArrayLayers);

    malloc.free(p);
    calloc.free(d);
  }

  @override
  String toString() => 'Queue';
}
