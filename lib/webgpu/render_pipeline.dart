import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'bind_group_layout.dart';
import 'device.dart';
import 'wgpu_object.dart';

class RenderPipeline extends WGpuObjectBase<wgpu.WGpuRenderPipeline> {
  /// The [Device] that created the pipeline.
  final Device device;

  RenderPipeline(this.device, wgpu.WGpuRenderPipeline o) : super(o, device);

  BindGroupLayout getBindGroupLayout(int index) {
    final o = libwebgpu.wgpu_pipeline_get_bind_group_layout(object, index);
    return BindGroupLayout.native(device, o);
  }
}
