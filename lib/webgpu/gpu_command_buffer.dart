import '../ffi/ffi_webgpu.dart' as wgpu;
import 'gpu_command_encoder.dart';
import 'gpu_object.dart';

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
class GPUCommandBuffer extends GPUObjectBase<wgpu.WGpuCommandBuffer> {
  /// The [GPUCommandEncoder] that owns this CommandBuffer.
  final GPUCommandEncoder encoder;

  GPUCommandBuffer(this.encoder, wgpu.WGpuCommandBuffer o)
      : super(o, encoder);
}
