import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'bind_group.dart';
import 'buffer.dart';
import 'command_encoder.dart';
import 'compute_pipeline.dart';
import 'wgpu_object.dart';

/// Encodes commands for a compute pass in a [CommandEncoder].
/// Created from CommandEncoder.beginComputePass.
class ComputePassEncoder extends WGpuObject<wgpu.WGpuComputePassEncoder> {
  CommandEncoder encoder;

  ComputePassEncoder(this.encoder, wgpu.WGpuComputePassEncoder o)
      : super(o, encoder);

  /// Set the current [ComputePipeline].
  void setPipeline(ComputePipeline pipeline) {
    libwebgpu.wgpu_encoder_set_pipeline(object, pipeline.object);
  }

  void setBindGroup(int index, BindGroup bindGroup,
      {List<int>? dynamicOffsets}) {
    final numDynamicOffsets = dynamicOffsets?.length ?? 0;
    final dynamicOffsetsPtr = calloc<Uint32>(numDynamicOffsets);
    if (dynamicOffsets != null) {
      for (var i = 0; i < numDynamicOffsets; ++i) {
        dynamicOffsetsPtr.elementAt(i).value = dynamicOffsets[i];
      }
    }

    libwebgpu.wgpu_encoder_set_bind_group(object, index, bindGroup.object,
        dynamicOffsetsPtr, numDynamicOffsets);
  }

  /// Dispatch work to be performed with the current ComputePipeline.
  void dispatchWorkgroups(int workgroupCountX, [int workgroupCountY = 1,
      int workgroupCountZ = 1]) {
    libwebgpu.wgpu_compute_pass_encoder_dispatch_workgroups(object,
        workgroupCountX, workgroupCountY, workgroupCountZ);
  }

  /// Dispatch work to be performed with the current ComputePipeline using
  /// parameters read from a [Buffer].
  void dispatchWorkgroupsIndirect(Buffer indirectBuffer, int indirectOffset) {
    libwebgpu.wgpu_compute_pass_encoder_dispatch_workgroups_indirect(object,
        indirectBuffer.object, indirectOffset);
  }

  /// Completes recording of the compute pass commands sequence.
  void end() {
    libwebgpu.wgpu_encoder_end(object);
  }
}
