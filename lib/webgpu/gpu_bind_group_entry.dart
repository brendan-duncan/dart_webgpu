import '../webgpu.dart';
import '_map_util.dart';

class GPUBindGroupEntry {
  final int binding;
  final GPUObject resource;
  final int bufferOffset;
  final int bufferSize;

  const GPUBindGroupEntry(
      {required this.binding,
      required this.resource,
      this.bufferOffset = 0,
      this.bufferSize = 0});

  factory GPUBindGroupEntry.fromMap(Map<String, Object> map) {
    final binding = mapValueRequired<int>(map['binding']);

    final r = map['resource'];
    if (r == null) {
      throw Exception('Invalid resource for GPUBindGroupEntry');
    }

    GPUObject resource;
    if (r is GPUBufferBinding) {
      resource = r;
    } else if (r is Map<String, Object>) {
      resource = mapObject<GPUBufferBinding>(r);
    } else {
      resource = mapValueRequired<GPUObject>(r);
    }

    final bufferOffset = mapValue(map['bufferOffset'], 0);
    final bufferSize = mapValue(map['bufferSize'], 0);

    return GPUBindGroupEntry(
        binding: binding,
        resource: resource,
        bufferOffset: bufferOffset,
        bufferSize: bufferSize);
  }
}
