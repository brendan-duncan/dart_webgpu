import '_map_util.dart';
import 'gpu_object.dart';

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
    final resource = mapValueRequired<GPUObject>(map['resource']);
    final bufferOffset = mapValue(map['bufferOffset'], 0);
    final bufferSize = mapValue(map['bufferSize'], 0);

    return GPUBindGroupEntry(
        binding: binding,
        resource: resource,
        bufferOffset: bufferOffset,
        bufferSize: bufferSize);
  }
}
