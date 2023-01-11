import 'dart:ffi';
import 'dart:math' show min;

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'buffer.dart';
import 'command_buffer.dart';
import 'compute_pass_descriptor.dart';
import 'compute_pass_encoder.dart';
import 'device.dart';
import 'image_copy_buffer.dart';
import 'image_copy_texture.dart';
import 'query_set.dart';
import 'render_pass_descriptor.dart';
import 'render_pass_encoder.dart';
import 'wgpu_object.dart';

/// A CommandEncoder generates commands for a CommandBuffer. A CommandEncoder
/// is created from a Device through the Device.createCommandEncoder method.
class CommandEncoder extends WGpuObjectBase<wgpu.WGpuCommandEncoder> {
  /// The [Device] that created this CommandEncoder.
  final Device device;

  CommandEncoder(this.device) {
    final o =
        libwebgpu.wgpu_device_create_command_encoder_simple(device.object);
    setObject(o);
    //device.addDependent(this);
  }

  /// Begins encoding a render pass described by descriptor.
  RenderPassEncoder beginRenderPass(Object descriptor) =>
      RenderPassEncoder(this, descriptor: descriptor);

  /// Begins encoding a compute pass described by descriptor.
  ComputePassEncoder beginComputePass(
          [ComputePassDescriptor descriptor = const ComputePassDescriptor()]) =>
      ComputePassEncoder(this, descriptor: descriptor);

  /// Encode a command into the CommandEncoder that copies data from a
  /// sub-region of a [Buffer] to a sub-region of another [Buffer].
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

  /// Encode a command into the CommandEncoder that copies data from a
  /// sub-region of a [Buffer] to a sub-region of one or multiple continuous
  /// texture subresources.
  void copyBufferToTexture(
      {required ImageCopyBuffer source,
      required ImageCopyTexture destination,
      required int width,
      int height = 1,
      int depthOrArrayLayers = 1}) {
    final s = calloc<wgpu.WGpuImageCopyBuffer>();
    s.ref
      ..offset = source.offset
      ..bytesPerRow = source.bytesPerRow
      ..rowsPerImage = source.rowsPerImage
      ..buffer = source.buffer.object;

    final numOrigin = destination.origin.length;
    final d = calloc<wgpu.WGpuImageCopyTexture>();
    d.ref
      ..texture = destination.texture.object
      ..mipLevel = destination.mipLevel
      ..origin.x = numOrigin > 0 ? destination.origin[0] : 0
      ..origin.y = numOrigin > 1 ? destination.origin[1] : 0
      ..origin.z = numOrigin > 2 ? destination.origin[2] : 0
      ..aspect = destination.aspect.nativeIndex;

    libwebgpu.wgpu_command_encoder_copy_buffer_to_texture(
        object, s, d, width, height, depthOrArrayLayers);

    calloc
      ..free(s)
      ..free(d);
  }

  /// Encode a command into the CommandEncoder that copies data from a
  /// sub-region of one or multiple continuous texture subresourcesto a
  /// sub-region of a [Buffer].
  void copyTextureToBuffer(
      {required ImageCopyTexture source,
      required ImageCopyBuffer destination,
      required int width,
      int height = 1,
      int depthOrArrayLayers = 1}) {
    final s = calloc<wgpu.WGpuImageCopyTexture>();
    final numOrigin = source.origin.length;
    s.ref
      ..texture = source.texture.object
      ..mipLevel = source.mipLevel
      ..origin.x = numOrigin > 0 ? source.origin[0] : 0
      ..origin.y = numOrigin > 1 ? source.origin[1] : 0
      ..origin.z = numOrigin > 2 ? source.origin[2] : 0
      ..aspect = source.aspect.nativeIndex;

    final d = calloc<wgpu.WGpuImageCopyBuffer>();
    d.ref
      ..offset = destination.offset
      ..bytesPerRow = destination.bytesPerRow
      ..rowsPerImage = destination.rowsPerImage
      ..buffer = destination.buffer.object;

    libwebgpu.wgpu_command_encoder_copy_texture_to_buffer(
        object, s, d, width, height, depthOrArrayLayers);

    calloc
      ..free(s)
      ..free(d);
  }

  /// Encode a command into the CommandEncoder that copies data from a
  /// sub-region of one or multiple contiguous texture subresources to another
  /// sub-region of one or multiple continuous texture subresources.
  void copyTextureToTexture(
      {required ImageCopyTexture source,
      required ImageCopyTexture destination,
      required int width,
      int height = 1,
      int depthOrArrayLayers = 1}) {
    final s = calloc<wgpu.WGpuImageCopyTexture>();
    final numOriginS = source.origin.length;
    s.ref
      ..texture = source.texture.object
      ..mipLevel = source.mipLevel
      ..origin.x = numOriginS > 0 ? source.origin[0] : 0
      ..origin.y = numOriginS > 1 ? source.origin[1] : 0
      ..origin.z = numOriginS > 2 ? source.origin[2] : 0
      ..aspect = source.aspect.nativeIndex;

    final numOriginD = destination.origin.length;
    final d = calloc<wgpu.WGpuImageCopyTexture>();
    d.ref
      ..texture = destination.texture.object
      ..mipLevel = destination.mipLevel
      ..origin.x = numOriginD > 0 ? destination.origin[0] : 0
      ..origin.y = numOriginD > 1 ? destination.origin[1] : 0
      ..origin.z = numOriginD > 2 ? destination.origin[2] : 0
      ..aspect = destination.aspect.nativeIndex;

    libwebgpu.wgpu_command_encoder_copy_texture_to_texture(
        object, s, d, width, height, depthOrArrayLayers);

    calloc
      ..free(s)
      ..free(d);
  }

  /// Encode a command into the CommandEncoder that fills a sub-region of a
  /// [Buffer] with zeros.
  void clearBuffer({required Buffer buffer, int offset = 0, int size = 0}) {
    libwebgpu.wgpu_command_encoder_clear_buffer(
        object, buffer.object, offset, size);
  }

  /// Writes a timestamp value into a [QuerySet] when all previous commands have
  /// completed executing.
  void writeTimestamp({required QuerySet querySet, required int queryIndex}) {
    libwebgpu.wgpu_command_encoder_write_timestamp(
        object, querySet.object, queryIndex);
  }

  /// Resolves query results from a [QuerySet] out into a range of a [Buffer].
  void resolveQuerySet(
      {required QuerySet querySet,
      required int firstQuery,
      required int queryCount,
      required Buffer destination,
      required int destinationOffset}) {
    libwebgpu.wgpu_command_encoder_resolve_query_set(object, querySet.object,
        firstQuery, queryCount, destination.object, destinationOffset);
  }

  /// Completes recording of the commands sequence and returns a corresponding
  /// [CommandBuffer].
  CommandBuffer finish() {
    final o = libwebgpu.wgpu_encoder_finish(object);
    return CommandBuffer(this, o);
  }
}
