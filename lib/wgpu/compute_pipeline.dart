import '../ffi/ffi_webgpu.dart' as wgpu;
import 'device.dart';
import 'wgpu_object.dart';

class ComputePipeline extends WGpuObject<wgpu.WGpuComputePipeline> {
  /// The [Device] that created the pipeline.
  Device device;
  ComputePipeline(this.device, wgpu.WGpuComputePipeline o) : super(o, device);
}
