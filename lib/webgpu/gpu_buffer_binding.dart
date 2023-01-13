import '_map_util.dart';
import 'gpu_buffer.dart';
import 'gpu_object.dart';

/// Describes a single resource to be bound in a GPUBindGroup.
///
/// Extended from GPUObject so it can be assigned to GPUBindGroupEntry.resource.
class GPUBufferBinding extends GPUObject {
  /// The GPUBuffer to bind.
  GPUBuffer buffer;
  /// The offset, in bytes, from the beginning of buffer to the beginning of the
  /// range exposed to the shader by the buffer binding.
  int offset;
  /// The size, in bytes, of the buffer binding. If undefined, specifies the
  /// range starting at offset and ending at the end of buffer.
  /// If 0, size is the remaining bytes of the buffer starting from offset.
  int size;

  GPUBufferBinding({ required this.buffer, this.offset = 0, this.size = 0});

  factory GPUBufferBinding.fromMap(Map<String, Object> map) {
    final buffer = mapValueRequired<GPUBuffer>(map['buffer']);
    final offset = mapValue<int>(map['offset'], 0);
    final size = mapValue<int>(map['size'], 0);
    return GPUBufferBinding(buffer: buffer, offset: offset, size: size);
  }
}
