import 'gpu_vertex_format.dart';

class GPUVertexAttribute {
  final GPUVertexFormat format;
  final int offset;
  final int shaderLocation;

  const GPUVertexAttribute(
      {required this.format,
      required this.offset,
      required this.shaderLocation});

  factory GPUVertexAttribute.fromMap(Map<String, Object> map) {
    if (map['format'] is! GPUVertexFormat ||
        map['offset'] is! int ||
        map['shaderLocation'] is! int) {
      throw Exception('Invalid data for VertexAttribute.');
    }
    return GPUVertexAttribute(
        format: map['format'] as GPUVertexFormat,
        offset: map['offset'] as int,
        shaderLocation: map['shaderLocation'] as int);
  }
}
