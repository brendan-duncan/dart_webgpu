import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_bind_group_layout.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';

/// A ComputePipeline is a kind of pipeline that controls the compute shader
/// stage, and can be used in ComputePassEncoder.
class GPUComputePipeline extends GPUObjectBase<wgpu.WGpuComputePipeline> {
  /// The [GPUDevice] that created the pipeline.
  final GPUDevice device;

  GPUComputePipeline(this.device, [wgpu.WGpuComputePipeline? o])
      : super(o, device);

  GPUBindGroupLayout getBindGroupLayout(int index) {
    final o = libwebgpu.wgpu_pipeline_get_bind_group_layout(object, index);
    return GPUBindGroupLayout.native(device, o);
  }
}
