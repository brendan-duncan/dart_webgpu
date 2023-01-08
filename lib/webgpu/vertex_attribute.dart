import 'vertex_format.dart';

class VertexAttribute {
  final VertexFormat format;
  final int offset;
  final int shaderLocation;

  const VertexAttribute(
      {required this.format,
      required this.offset,
      required this.shaderLocation});
}
