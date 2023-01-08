import 'dart:ffi';
import 'dart:math' show min;

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'buffer.dart';
import 'command_buffer.dart';
import 'compute_pass_encoder.dart';
import 'device.dart';
import 'wgpu_object.dart';

/// A CommandEncoder generates commands for a CommandBuffer. A CommandEncoder
/// is created from a Device through the Device.createCommandEncoder method.
class CommandEncoder extends WGpuObject<wgpu.WGpuCommandEncoder> {
  /// The [Device] that created this CommandEncoder.
  final Device device;

  CommandEncoder(this.device) {
    final o =
        libwebgpu.wgpu_device_create_command_encoder_simple(device.object);
    setObject(o);
    device.addDependent(this);
  }

  //RenderPassEncoder beginRenderPass(RenderPassDescriptor descriptor) {}

  ComputePassEncoder beginComputePass() {
    final desc = calloc<wgpu.WGpuComputePassDescriptor>();
    desc.ref.numTimestampWrites = 0;
    final o = libwebgpu.wgpu_command_encoder_begin_compute_pass(object, desc);
    return ComputePassEncoder(this, o);
  }

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

  CommandBuffer finish() {
    final buffer = libwebgpu.wgpu_encoder_finish(object);
    return CommandBuffer(device, buffer);
  }
}
