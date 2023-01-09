import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'command_encoder.dart';
import 'render_pass_descriptor.dart';
import 'wgpu_object.dart';

/// Encodes commands for a render pass in a [CommandEncoder].
/// Created from CommandEncoder.beginRenderPass.
class RenderPassEncoder extends WGpuObjectBase<wgpu.WGpuComputePassEncoder> {
  final CommandEncoder encoder;

  RenderPassEncoder(this.encoder, {required RenderPassDescriptor descriptor}) {
    encoder.addDependent(this);

    final d = calloc<wgpu.WGpuRenderPassDescriptor>();

    d.ref.maxDrawCount = descriptor.maxDrawCount;

    if (descriptor.occlusionQuerySet != null) {
      d.ref.occlusionQuerySet = descriptor.occlusionQuerySet!.object;
    }

    if (descriptor.depthStencilAttachment != null) {
      final dsa = descriptor.depthStencilAttachment!;
      d.ref.depthStencilAttachment
        ..view = dsa.view.object
        ..depthLoadOp = dsa.depthLoadOp?.nativeIndex ?? 0
        ..depthStoreOp = dsa.depthStoreOp?.nativeIndex ?? 0
        ..depthReadOnly = dsa.depthReadOnly ? 1 : 0
        ..depthClearValue = dsa.depthClearValue.toDouble()
        ..stencilLoadOp = dsa.stencilLoadOp?.nativeIndex ?? 0
        ..stencilStoreOp = dsa.stencilStoreOp?.nativeIndex ?? 0
        ..stencilReadOnly = dsa.stencilReadOnly ? 1 : 0
        ..stencilClearValue = dsa.stencilClearValue;
    }

    final numColorAttachments = descriptor.colorAttachments.length;
    d.ref.numColorAttachments = numColorAttachments;

    if (numColorAttachments > 0) {
      d.ref.colorAttachments =
          calloc<wgpu.WGpuRenderPassColorAttachment>(numColorAttachments);

      for (var i = 0; i < numColorAttachments; ++i) {
        final ca = descriptor.colorAttachments[i];
        final nc = ca.clearValue.length;

        final dca = d.ref.colorAttachments.elementAt(i).ref
          ..view = ca.view.object
          ..storeOp = ca.storeOp.nativeIndex
          ..loadOp = ca.loadOp.nativeIndex
          ..clearValue.r = nc > 0 ? ca.clearValue[0].toDouble() : 0.0
          ..clearValue.g = nc > 1 ? ca.clearValue[1].toDouble() : 0.0
          ..clearValue.b = nc > 2 ? ca.clearValue[2].toDouble() : 0.0
          ..clearValue.a = nc > 3 ? ca.clearValue[3].toDouble() : 0.0;

        if (ca.resolveTarget != null) {
          dca.resolveTarget = ca.resolveTarget!.object;
        }
      }
    }

    final numTimestampWrites = descriptor.timestampWrites?.length ?? 0;
    d.ref.numTimestampWrites = numTimestampWrites;
    if (numTimestampWrites > 0) {
      d.ref.timestampWrites =
          calloc<wgpu.WGpuRenderPassTimestampWrite>(numTimestampWrites);
      for (var i = 0; i < numTimestampWrites; ++i) {
        final tsw = descriptor.timestampWrites![i];
        d.ref.timestampWrites.elementAt(i).ref
          ..location = tsw.location.nativeIndex
          ..queryIndex = tsw.queryIndex
          ..querySet = tsw.querySet.object;
      }
    }

    final o =
        libwebgpu.wgpu_command_encoder_begin_render_pass(encoder.object, d);

    setObject(o);

    if (numColorAttachments > 0) {
      calloc.free(d.ref.colorAttachments);
    }

    if (numTimestampWrites > 0) {
      calloc.free(d.ref.timestampWrites);
    }

    calloc.free(d);
  }

  /// Completes recording of the render pass commands sequence.
  void end() {
    libwebgpu.wgpu_encoder_end(object);
  }
}
