import '../ffi/ffi_webgpu.dart' as wgpu;
import 'device.dart';
import 'wgpu_object.dart';

class RenderPipeline extends WGpuObjectBase<wgpu.WGpuRenderPipeline> {
  /// The [Device] that created the pipeline.
  final Device device;
  RenderPipeline(this.device, wgpu.WGpuRenderPipeline o) : super(o, device);
}
