import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'bind_group.dart';
import 'buffer.dart';
import 'command_encoder.dart';
import 'index_format.dart';
import 'render_pass_descriptor.dart';
import 'render_pipeline.dart';
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

  /// Sets the current [BindGroup] for the given index.
  void setBindGroup(int index, BindGroup bindGroup,
    [List<int>? dynamicOffsets]) {
    final numDynamicOffsets = dynamicOffsets?.length ?? 0;
    final p = calloc<Uint32>(numDynamicOffsets);
    for (int i = 0; i < numDynamicOffsets; ++i) {
      p.elementAt(i).value = dynamicOffsets![i];
    }
    libwebgpu.wgpu_encoder_set_bind_group(object, index, bindGroup.object,
        p, numDynamicOffsets);
    calloc.free(p);
  }

  /// Sets the current GPURenderPipeline.
  void setPipeline(RenderPipeline pipeline) {
    libwebgpu.wgpu_encoder_set_pipeline(object, pipeline.object);
  }

  /// Sets the current index buffer.
  void setIndexBuffer(Buffer buffer, IndexFormat indexFormat,
      [int offset = 0, int size = 0]) {
    libwebgpu.wgpu_render_commands_mixin_set_index_buffer(object, buffer.object,
        indexFormat.nativeIndex, offset, size);
  }

  /// Sets the current vertex buffer for the given slot.
  void setVertexBuffer(int slot, Buffer buffer,
      [int offset = 0, int size = 0]) {
    libwebgpu.wgpu_render_commands_mixin_set_vertex_buffer(object, slot,
        buffer.object, offset, size);
  }

  /// Draws primitives.
  void draw(int vertexCount, [int instanceCount = 1,
      int firstVertex = 0, int firstInstance = 0]) {
    libwebgpu.wgpu_render_commands_mixin_draw(object, vertexCount,
        instanceCount, firstVertex, firstInstance);
  }

  /// Draws indexed primitives.
  void drawIndexed(int indexCount, [int instanceCount = 1,
      int firstVertex = 0,
      int baseVertex = 0,
      int firstInstance = 0]) {
    libwebgpu.wgpu_render_commands_mixin_draw_indexed(object, indexCount,
        instanceCount, firstVertex, baseVertex, firstInstance);
  }

  /// Draws primitives using parameters read from a [Buffer].
  void drawIndirect(Buffer indirectBuffer, int indirectOffset) {
    libwebgpu.wgpu_render_commands_mixin_draw_indirect(object,
        indirectBuffer.object, indirectOffset);
  }

  /// Draws indexed primitives using parameters read from a [Buffer].
  void drawIndexedIndirect(Buffer indirectBuffer, int indirectOffset) {
    libwebgpu.wgpu_render_commands_mixin_draw_indexed_indirect(object,
        indirectBuffer.object, indirectOffset);
  }

  /// Sets the viewport used during the rasterization stage to linearly map
  /// from normalized device coordinates to viewport coordinates.
  void setViewport(num x, num y, num width, num height, num minDepth,
      num maxDepth) {
    libwebgpu.wgpu_render_pass_encoder_set_viewport(object, x.toDouble(),
        y.toDouble(), width.toDouble(), height.toDouble(),
        minDepth.toDouble(), maxDepth.toDouble());
  }

  /// Sets the scissor rectangle used during the rasterization stage. After
  /// transformation into viewport coordinates any fragments which fall outside
  /// the scissor rectangle will be discarded.
  void setScissorRect(int x, int y, int width, int height) {
    libwebgpu.wgpu_render_pass_encoder_set_scissor_rect(object, x, y,
        width, height);
  }

  /// Sets the constant blend color and alpha values used with "constant" and
  /// "one-minus-constant" BlendFactors.
  void setBlendConstant(num r, num g, num b, num a) {
    libwebgpu.wgpu_render_pass_encoder_set_blend_constant(object,
        r.toDouble(), g.toDouble(), b.toDouble(), a.toDouble());
  }

  /// Sets the stencilReference value used during stencil tests with the
  /// "replace" StencilOperation.
  void setStencilReference(int reference) {
    libwebgpu.wgpu_render_pass_encoder_set_stencil_reference(object, reference);
  }

  void beginOcclusionQuery(int queryIndex) {
    libwebgpu.wgpu_render_pass_encoder_begin_occlusion_query(object,
        queryIndex);
  }

  void endOcclusionQuery() {
    libwebgpu.wgpu_render_pass_encoder_end_occlusion_query(object);
  }

  /*void executeBundles(List<RenderBundle> bundles) {
  }*/

  /// Completes recording of the render pass commands sequence.
  void end() {
    libwebgpu.wgpu_encoder_end(object);
  }
}
