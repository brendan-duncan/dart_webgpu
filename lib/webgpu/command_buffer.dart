import '../ffi/ffi_webgpu.dart' as wgpu;
import 'device.dart';
import 'wgpu_object.dart';

/// Command buffers are pre-recorded lists of GPU commands that can be submitted
/// to a Queue for execution. Each GPU command represents a task to be performed
/// on the GPU, such as setting state, drawing, copying resources, etc.
///
/// A CommandBuffer can only be submitted once, at which point it becomes
/// invalid. To reuse rendering commands across multiple submissions, use
/// RenderBundle.
///
/// A CommandBuffer is created from a CommandEncoder with the
/// CommandEncoder.finish method.
class CommandBuffer extends WGpuObject<wgpu.WGpuCommandBuffer> {
  /// The Device that owns this CommandBuffer.
  final Device device;
  CommandBuffer(this.device, wgpu.WGpuCommandBuffer o) : super(o, device);
}
