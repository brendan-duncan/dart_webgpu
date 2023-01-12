import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_bind_group_layout.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';

/// A ComputePipeline is a kind of pipeline that controls the compute shader
/// stage, and can be used in ComputePassEncoder.
class GpuComputePipeline extends GpuObjectBase<wgpu.WGpuComputePipeline> {
  /// The [GpuDevice] that created the pipeline.
  final GpuDevice device;

  GpuComputePipeline(this.device, [wgpu.WGpuComputePipeline? o])
      : super(o, device);

  GpuBindGroupLayout getBindGroupLayout(int index) {
    final o = libwebgpu.wgpu_pipeline_get_bind_group_layout(object, index);
    return GpuBindGroupLayout.native(device, o);
  }
}
