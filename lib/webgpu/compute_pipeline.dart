import '../ffi/ffi_webgpu.dart' as wgpu;
import 'device.dart';
import 'wgpu_object.dart';

/// A ComputePipeline is a kind of pipeline that controls the compute shader
/// stage, and can be used in ComputePassEncoder.
class ComputePipeline extends WGpuObjectBase<wgpu.WGpuComputePipeline> {
  /// The [Device] that created the pipeline.
  final Device device;

  ComputePipeline(this.device, wgpu.WGpuComputePipeline o) : super(o, device);
}
