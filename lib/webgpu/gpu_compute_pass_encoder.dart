import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_bind_group.dart';
import 'gpu_buffer.dart';
import 'gpu_command_encoder.dart';
import 'gpu_compute_pass_descriptor.dart';
import 'gpu_compute_pipeline.dart';
import 'gpu_object.dart';

/// Encodes commands for a compute pass in a [GPUCommandEncoder].
/// Created from CommandEncoder.beginComputePass.
class GPUComputePassEncoder extends GPUObjectBase<wgpu.WGpuComputePassEncoder> {
  late final GPUComputePassDescriptor descriptor;

  GPUComputePassEncoder(GPUCommandEncoder encoder,
      {GPUComputePassDescriptor descriptor =
          const GPUComputePassDescriptor()}) {
    encoder.addDependent(this);

    final desc = descriptor;
    this.descriptor = desc;

    final d = calloc<wgpu.WGpuComputePassDescriptor>();

    final o =
        libwebgpu.wgpu_command_encoder_begin_compute_pass(encoder.object, d);
    setObject(o);

    calloc.free(d);
  }

  /// Set the current [GPUComputePipeline].
  void setPipeline(GPUComputePipeline pipeline) {
    libwebgpu.wgpu_encoder_set_pipeline(object, pipeline.object);
  }

  void setBindGroup(int index, GPUBindGroup bindGroup,
      {List<int>? dynamicOffsets}) {
    final numDynamicOffsets = dynamicOffsets?.length ?? 0;
    final dynamicOffsetsPtr = calloc<Uint32>(numDynamicOffsets);
    if (dynamicOffsets != null) {
      for (var i = 0; i < numDynamicOffsets; ++i) {
        dynamicOffsetsPtr.elementAt(i).value = dynamicOffsets[i];
      }
    }

    libwebgpu.wgpu_encoder_set_bind_group(
        object, index, bindGroup.object, dynamicOffsetsPtr, numDynamicOffsets);
  }

  /// Dispatch work to be performed with the current ComputePipeline.
  void dispatchWorkgroups(int workgroupCountX,
      [int workgroupCountY = 1, int workgroupCountZ = 1]) {
    libwebgpu.wgpu_compute_pass_encoder_dispatch_workgroups(
        object, workgroupCountX, workgroupCountY, workgroupCountZ);
  }

  /// Dispatch work to be performed with the current ComputePipeline using
  /// parameters read from a [GPUBuffer].
  void dispatchWorkgroupsIndirect(
      GPUBuffer indirectBuffer, int indirectOffset) {
    libwebgpu.wgpu_compute_pass_encoder_dispatch_workgroups_indirect(
        object, indirectBuffer.object, indirectOffset);
  }

  /// Completes recording of the compute pass commands sequence.
  void end() {
    libwebgpu.wgpu_encoder_end(object);
    // wgpu_encoder_end destroys the wgpu object.
    webgpu.detachFinalizer(this);
    objectPtr = nullptr;
  }
}
