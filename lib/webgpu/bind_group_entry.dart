import '../webgpu.dart';

class BindGroupEntry {
  final int binding;
  final WGpuObjectBase resource;
  final int bufferOffset;
  final int bufferSize;
  const BindGroupEntry({ required this.binding, required this.resource,
    this.bufferOffset = 0, this.bufferSize = 0});
}
