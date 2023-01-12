import '_map_util.dart';
import 'gpu_object.dart';

class GpuBindGroupEntry {
  final int binding;
  final GpuObject resource;
  final int bufferOffset;
  final int bufferSize;

  const GpuBindGroupEntry(
      {required this.binding,
      required this.resource,
      this.bufferOffset = 0,
      this.bufferSize = 0});

  factory GpuBindGroupEntry.fromMap(Map<String, Object> map) {
    final binding = getMapValueRequired<int>(map['binding']);
    final resource = getMapValueRequired<GpuObject>(map['resource']);
    final bufferOffset = getMapValue(map['bufferOffset'], 0);
    final bufferSize = getMapValue(map['bufferSize'], 0);

    return GpuBindGroupEntry(
        binding: binding,
        resource: resource,
        bufferOffset: bufferOffset,
        bufferSize: bufferSize);
  }
}
