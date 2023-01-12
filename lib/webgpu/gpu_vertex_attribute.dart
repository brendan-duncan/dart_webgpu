import 'gpu_vertex_format.dart';

class GpuVertexAttribute {
  final GpuVertexFormat format;
  final int offset;
  final int shaderLocation;

  const GpuVertexAttribute(
      {required this.format,
      required this.offset,
      required this.shaderLocation});

  factory GpuVertexAttribute.fromMap(Map<String, Object> map) {
    if (map['format'] is! GpuVertexFormat ||
        map['offset'] is! int ||
        map['shaderLocation'] is! int) {
      throw Exception('Invalid data for VertexAttribute.');
    }
    return GpuVertexAttribute(
        format: map['format'] as GpuVertexFormat,
        offset: map['offset'] as int,
        shaderLocation: map['shaderLocation'] as int);
  }
}
