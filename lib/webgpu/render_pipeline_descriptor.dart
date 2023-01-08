import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import 'depth_stencil_state.dart';
import 'fragment_state.dart';
import 'multisample_state.dart';
import 'primitive_state.dart';
import 'vertex_state.dart';

class RenderPipelineDescriptor {
  final VertexState vertex;
  final PrimitiveState? primitive;
  final DepthStencilState? depthStencil;
  final MultisampleState? multisample;
  final FragmentState? fragment;

  const RenderPipelineDescriptor(
      {required this.vertex,
      this.primitive,
      this.depthStencil,
      this.multisample,
      this.fragment});

  Pointer<wgpu.WGpuRenderPipelineDescriptor> toNative() {
    final d = calloc<wgpu.WGpuRenderPipelineDescriptor>();

    final ref = d.ref;

    { // vertex
      final v = vertex;
      final numBuffers = v.buffers?.length ?? 0;
      final numConstants = v.constants?.length ?? 0;

      ref.vertex
        ..module = v.module.object
        ..entryPoint = v.entryPoint.toNativeUtf8().cast<Char>()
        ..numBuffers = numBuffers
        ..buffers = calloc<wgpu.WGpuVertexBufferLayout>(numBuffers)
        ..numConstants = numConstants
        ..constants = malloc<wgpu.WGpuPipelineConstant>(numConstants);

      for (var i = 0; i < numBuffers; ++i) {
        final b = v.buffers![i];
        final numAttrs = b.attributes.length;
        final rb = ref.vertex.buffers.elementAt(i).ref
          ..arrayStride = b.arrayStride
          ..stepMode = b.stepMode.index
          ..numAttributes = numAttrs
          ..attributes = malloc<wgpu.WGpuVertexAttribute>(numAttrs);
        for (var j = 0; j < numAttrs; ++j) {
          final a = b.attributes[j];
          rb.attributes.elementAt(j) .ref
            ..offset = a.offset
            ..shaderLocation = a.shaderLocation
            ..format = a.format.index;
        }
      }
    }

    if (primitive != null) {
      ref.primitive
        ..topology = primitive!.topology.index
        ..stripIndexFormat = primitive!.stripIndexFormat.index
        ..frontFace = primitive!.frontFace.index
        ..cullMode = primitive!.cullMode.index
        ..unclippedDepth = primitive!.unclippedDepth ? 1 : 0;
    }

    if (depthStencil != null) {
      final ds = depthStencil!;
      ref.depthStencil
          ..format = ds.format.index
          ..depthWriteEnabled = ds.depthWriteEnabled ? 1 : 0
          ..depthCompare = ds.depthCompare.index
          ..stencilReadMask = ds.stencilReadMask
          ..stencilWriteMask = ds.stencilWriteMask
          ..depthBias = ds.depthBias
          ..depthBiasSlopeScale = ds.depthBiasSlopeScale.toDouble()
          ..depthBiasClamp = ds.depthBiasClamp.toDouble()
          ..stencilFront.compare = ds.stencilFront.compare.index
          ..stencilFront.failOp = ds.stencilFront.failOp.index
          ..stencilFront.depthFailOp = ds.stencilFront.depthFailOp.index
          ..stencilFront.passOp = ds.stencilFront.passOp.index
          ..stencilBack.compare = ds.stencilBack.compare.index
          ..stencilBack.failOp = ds.stencilBack.failOp.index
          ..stencilBack.depthFailOp = ds.stencilBack.depthFailOp.index
          ..stencilBack.passOp = ds.stencilBack.passOp.index
          ..clampDepth = 0;
    }

    if (multisample != null) {
      final ms = multisample!;
      ref.multisample
        ..count = ms.count
        ..mask = ms.mask
        ..alphaToCoverageEnabled = ms.alphaToCoverageEnabled ? 1 : 0;
    }

    if (fragment != null) {
      final f = fragment!;
      final numConstants = f.constants?.length ?? 0;
      final numTargets = f.targets.length;
      ref.fragment
        ..module = f.module.object
        ..entryPoint = f.entryPoint.toNativeUtf8().cast<Char>()
        ..numTargets = f.targets.length
        ..targets = malloc<wgpu.WGpuColorTargetState>(numTargets)
        ..numConstants = numConstants
        ..constants = malloc<wgpu.WGpuPipelineConstant>(numConstants);

      final rt = ref.fragment.targets;
      for (var i = 0; i < numTargets; ++i) {
        final t = f.targets[i];
        rt.elementAt(i).ref
          ..format = t.format.index
          ..writeMask = t.writeMask.value
          ..blend.color.operation = t.blend?.color.operation.index ?? 0
          ..blend.color.srcFactor = t.blend?.color.srcFactor.index ?? 0
          ..blend.color.dstFactor = t.blend?.color.dstFactor.index ?? 0
          ..blend.alpha.operation = t.blend?.alpha.operation.index ?? 0
          ..blend.alpha.srcFactor = t.blend?.alpha.srcFactor.index ?? 0
          ..blend.alpha.dstFactor = t.blend?.alpha.dstFactor.index ?? 0;
      }
    }

    return d;
  }

  void deleteNative(Pointer<wgpu.WGpuRenderPipelineDescriptor> d) {
    malloc.free(d.ref.vertex.entryPoint);
    calloc.free(d);
  }
}
