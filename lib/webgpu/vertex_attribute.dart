import 'vertex_format.dart';

class VertexAttribute {
  final VertexFormat format;
  final int offset;
  final int shaderLocation;

  const VertexAttribute(
      {required this.format,
      required this.offset,
      required this.shaderLocation});

  factory VertexAttribute.fromMap(Map<String, Object> map) {
    if (map['format'] is! VertexFormat ||
        map['offset'] is! int ||
        map['shaderLocation'] is! int) {
      throw Exception('Invalid data for VertexAttribute.');
    }
    return VertexAttribute(
        format: map['format'] as VertexFormat,
        offset: map['offset'] as int,
        shaderLocation: map['shaderLocation'] as int);
  }
}
