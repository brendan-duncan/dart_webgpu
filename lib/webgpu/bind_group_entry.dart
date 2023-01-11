import '_map_util.dart';
import 'wgpu_object.dart';

class BindGroupEntry {
  final int binding;
  final WGpuObject resource;
  final int bufferOffset;
  final int bufferSize;

  const BindGroupEntry(
      {required this.binding,
      required this.resource,
      this.bufferOffset = 0,
      this.bufferSize = 0});

  factory BindGroupEntry.fromMap(Map<String, Object> map) {
    final binding = getMapValueRequired<int>(map['binding']);
    final resource = getMapValueRequired<WGpuObject>(map['resource']);
    final bufferOffset = getMapValue(map['bufferOffset'], 0);
    final bufferSize = getMapValue(map['bufferSize'], 0);

    return BindGroupEntry(
        binding: binding,
        resource: resource,
        bufferOffset: bufferOffset,
        bufferSize: bufferSize);
  }
}
