import '_map_util.dart';
import 'gpu_vertex_format.dart';

class GPUVertexAttribute {
  final GPUVertexFormat format;
  final int offset;
  final int shaderLocation;

  const GPUVertexAttribute(
      {required this.format,
      required this.offset,
      required this.shaderLocation});

  factory GPUVertexAttribute.fromMap(Map<String, Object> map) =>
      GPUVertexAttribute(
          format: mapValueRequired<GPUVertexFormat>(map['format']),
          offset: mapValueRequired<int>(map['offset']),
          shaderLocation: mapValueRequired<int>(map['shaderLocation']));
}
