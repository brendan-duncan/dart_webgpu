import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_bind_group_layout.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';

class GpuRenderPipeline extends GpuObjectBase<wgpu.WGpuRenderPipeline> {
  /// The [GpuDevice] that created the pipeline.
  final GpuDevice device;

  GpuRenderPipeline(this.device, [wgpu.WGpuRenderPipeline? o])
      : super(o, device);

  GpuBindGroupLayout getBindGroupLayout(int index) {
    if (!isValid) {
      throw Exception(
          'Attempting to use a RenderPipeline that has not been created');
    }
    final o = libwebgpu.wgpu_pipeline_get_bind_group_layout(object, index);
    return GpuBindGroupLayout.native(device, o);
  }
}
