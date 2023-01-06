import 'dart:math' show min;

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'buffer.dart';
import 'command_buffer.dart';
import 'device.dart';
import 'wgpu_object.dart';

/// A CommandEncoder generates commands for a CommandBuffer. A CommandEncoder
/// is created from a Device through the Device.createCommandEncoder method.
class CommandEncoder extends WGpuObject<wgpu.WGpuCommandEncoder> {
  /// The [Device] that created this CommandEncoder.
  Device device;

  CommandEncoder(this.device) {
    final o =
        libwebgpu.wgpu_device_create_command_encoder_simple(device.object);
    setObject(o);
    device.addDependent(this);
  }

  //RenderPassEncoder beginRenderPass(RenderPassDescriptor descriptor) {}
  //ComputePassEncoder beginComputePass(ComputePassDescriptor? descriptor) {}

  void copyBufferToBuffer(
      {required Buffer source,
      int sourceOffset = 0,
      required Buffer destination,
      int destinationOffset = 0,
      int size = 0}) {
    if (size == 0) {
      size = min(source.size, destination.size);
    }
    libwebgpu.wgpu_command_encoder_copy_buffer_to_buffer(object, source.object,
        sourceOffset, destination.object, destinationOffset, size);
  }

  /*void copyBufferToTexture(
      ImageCopyBuffer source,
      ImageCopyTexture destination,
      Extent3D copySize) {}

  void copyTextureToBuffer(
      ImageCopyTexture source,
      ImageCopyBuffer destination,
      Extent3D copySize) {}

  void copyTextureToTexture(
      ImageCopyTexture source,
      ImageCopyTexture destination,
      Extent3D copySize) {}

  void clearBuffer(Buffer buffer, { int offset = 0, int size = 0 }) {}

  void writeTimestamp(QuerySet querySet, int queryIndex) {}

  void resolveQuerySet(
      QuerySet querySet,
      int firstQuery,
      int queryCount,
      Buffer destination,
      int destinationOffset) {}*/

  CommandBuffer finish() {
    final buffer = libwebgpu.wgpu_encoder_finish(object);
    return CommandBuffer(device, buffer);
  }
}
