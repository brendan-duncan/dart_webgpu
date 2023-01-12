import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '_map_util.dart';
import 'gpu_depth_stencil_state.dart';
import 'gpu_fragment_state.dart';
import 'gpu_multisample_state.dart';
import 'gpu_pipeline_layout.dart';
import 'gpu_primitive_state.dart';
import 'gpu_vertex_state.dart';

class GPURenderPipelineDescriptor {
  final GPUPipelineLayout? layout;
  final GPUVertexState vertex;
  final GPUPrimitiveState? primitive;
  final GPUDepthStencilState? depthStencil;
  final GPUMultisampleState? multisample;
  final GPUFragmentState? fragment;

  const GPURenderPipelineDescriptor(
      {required this.vertex,
      this.layout,
      this.primitive,
      this.depthStencil,
      this.multisample,
      this.fragment});

  factory GPURenderPipelineDescriptor.fromMap(Map<String, Object> map) {
    final layout = getMapValue<GPUPipelineLayout?>(map['layout'], null);
    final vertex = getMapObject<GPUVertexState>(map['vertex']);
    final fragment = getMapObjectNullable<GPUFragmentState>(map['fragment']);
    final primitive = getMapObjectNullable<GPUPrimitiveState>(map['primitive']);
    final depthStencil =
        getMapObjectNullable<GPUDepthStencilState>(map['depthStencil']);
    final multisample =
        getMapObjectNullable<GPUMultisampleState>(map['multisample']);

    return GPURenderPipelineDescriptor(
        layout: layout,
        vertex: vertex,
        fragment: fragment,
        primitive: primitive,
        depthStencil: depthStencil,
        multisample: multisample);
  }

  Pointer<wgpu.WGpuRenderPipelineDescriptor> toNative() {
    final d = calloc<wgpu.WGpuRenderPipelineDescriptor>();

    final ref = d.ref;

    if (layout != null) {
      ref.layout = layout!.object;
    }

    // vertex
    {
      final v = vertex;
      final numBuffers = v.buffers?.length ?? 0;
      final numConstants = v.constants?.length ?? 0;

      ref.vertex
        ..module = v.module.object
        ..entryPoint = v.entryPoint.toNativeUtf8().cast<Char>()
        ..numBuffers = numBuffers
        ..buffers = calloc<wgpu.WGpuVertexBufferLayout>(numBuffers)
        ..numConstants = numConstants
        ..constants = calloc<wgpu.WGpuPipelineConstant>(numConstants);

      if (v.constants != null) {
        final c = ref.vertex.constants;
        final constants = v.constants as Map<String, num>;
        var i = 0;
        for (final e in constants.entries) {
          final name = e.key.toNativeUtf8();
          final value = e.value.toDouble();
          c.elementAt(i).ref.name = name.cast<Char>();
          c.elementAt(i).ref.value = value;
          i++;
        }
      }

      for (var i = 0; i < numBuffers; ++i) {
        final b = v.buffers![i];
        final numAttrs = b.attributes.length;
        final rb = ref.vertex.buffers.elementAt(i).ref
          ..arrayStride = b.arrayStride
          ..stepMode = b.stepMode.nativeIndex
          ..numAttributes = numAttrs
          ..attributes = malloc<wgpu.WGpuVertexAttribute>(numAttrs);
        for (var j = 0; j < numAttrs; ++j) {
          final a = b.attributes[j];
          rb.attributes.elementAt(j).ref
            ..offset = a.offset
            ..shaderLocation = a.shaderLocation
            ..format = a.format.nativeIndex;
        }
      }
    }

    final prim = primitive ?? const GPUPrimitiveState();
    ref.primitive
      ..topology = prim.topology.nativeIndex
      ..stripIndexFormat = prim.stripIndexFormat.nativeIndex
      ..frontFace = prim.frontFace.nativeIndex
      ..cullMode = prim.cullMode.nativeIndex
      ..unclippedDepth = prim.unclippedDepth ? 1 : 0;

    if (depthStencil != null) {
      final ds = depthStencil!;
      ref.depthStencil
        ..format = ds.format.nativeIndex
        ..depthWriteEnabled = ds.depthWriteEnabled ? 1 : 0
        ..depthCompare = ds.depthCompare.nativeIndex
        ..stencilReadMask = ds.stencilReadMask
        ..stencilWriteMask = ds.stencilWriteMask
        ..depthBias = ds.depthBias
        ..depthBiasSlopeScale = ds.depthBiasSlopeScale.toDouble()
        ..depthBiasClamp = ds.depthBiasClamp.toDouble()
        ..stencilFront.compare = ds.stencilFront.compare.nativeIndex
        ..stencilFront.failOp = ds.stencilFront.failOp.nativeIndex
        ..stencilFront.depthFailOp = ds.stencilFront.depthFailOp.nativeIndex
        ..stencilFront.passOp = ds.stencilFront.passOp.nativeIndex
        ..stencilBack.compare = ds.stencilBack.compare.nativeIndex
        ..stencilBack.failOp = ds.stencilBack.failOp.nativeIndex
        ..stencilBack.depthFailOp = ds.stencilBack.depthFailOp.nativeIndex
        ..stencilBack.passOp = ds.stencilBack.passOp.nativeIndex
        ..clampDepth = 0;
    }

    final ms = multisample ?? const GPUMultisampleState();
    ref.multisample
      ..count = ms.count
      ..mask = ms.mask
      ..alphaToCoverageEnabled = ms.alphaToCoverageEnabled ? 1 : 0;

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

      if (f.constants != null) {
        final c = ref.fragment.constants;
        final constants = f.constants as Map<String, num>;
        var i = 0;
        for (final e in constants.entries) {
          final name = e.key.toNativeUtf8();
          final value = e.value.toDouble();
          c.elementAt(i).ref.name = name.cast<Char>();
          c.elementAt(i).ref.value = value;
          i++;
        }
      }

      final rt = ref.fragment.targets;
      for (var i = 0; i < numTargets; ++i) {
        final t = f.targets[i];
        rt.elementAt(i).ref
          ..format = t.format.nativeIndex
          ..writeMask = t.writeMask.value
          ..blend.color.operation = t.blend?.color.operation.nativeIndex ?? 0
          ..blend.color.srcFactor = t.blend?.color.srcFactor.nativeIndex ?? 0
          ..blend.color.dstFactor = t.blend?.color.dstFactor.nativeIndex ?? 0
          ..blend.alpha.operation = t.blend?.alpha.operation.nativeIndex ?? 0
          ..blend.alpha.srcFactor = t.blend?.alpha.srcFactor.nativeIndex ?? 0
          ..blend.alpha.dstFactor = t.blend?.alpha.dstFactor.nativeIndex ?? 0;
      }
    }

    return d;
  }

  void deleteNative(Pointer<wgpu.WGpuRenderPipelineDescriptor> d) {
    malloc.free(d.ref.vertex.entryPoint);
    for (var i = 0; i < d.ref.vertex.numConstants; ++i) {
      malloc
        ..free(d.ref.vertex.constants.elementAt(i).ref.name)
        ..free(d.ref.vertex.constants.elementAt(i));
    }
    for (var i = 0; i < d.ref.vertex.numBuffers; ++i) {
      malloc.free(d.ref.vertex.buffers.elementAt(i).ref.attributes);
    }
    malloc
      ..free(d.ref.vertex.buffers)
      ..free(d.ref.fragment.entryPoint);
    for (var i = 0; i < d.ref.fragment.numTargets; ++i) {
      malloc.free(d.ref.fragment.targets.elementAt(i));
    }
    for (var i = 0; i < d.ref.fragment.numConstants; ++i) {
      malloc
        ..free(d.ref.fragment.constants.elementAt(i).ref.name)
        ..free(d.ref.fragment.constants.elementAt(i));
    }

    calloc.free(d);
  }
}
