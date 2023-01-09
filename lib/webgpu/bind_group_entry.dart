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
}
