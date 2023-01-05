import '../ffi/ffi_webgpu.dart' as wgpu;
import 'wgpu_object.dart';

class CommandBuffer extends WGpuObject<wgpu.WGpuCommandBuffer> {
  CommandBuffer(wgpu.WGpuCommandBuffer o) : super(o);
}
