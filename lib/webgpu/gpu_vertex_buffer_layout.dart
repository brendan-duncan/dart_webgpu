import 'gpu_vertex_attribute.dart';
import 'gpu_vertex_step_mode.dart';

class GPUVertexBufferLayout {
  final int arrayStride;
  final GPUVertexStepMode stepMode;
  final List<GPUVertexAttribute> attributes;

  const GPUVertexBufferLayout(
      {required this.arrayStride,
      this.stepMode = GPUVertexStepMode.vertex,
      required this.attributes});

  factory GPUVertexBufferLayout.fromMap(Map<String, Object> map) {
    if (map['arrayStride'] is! int || map['attributes'] is! List) {
      throw Exception('Invalid data for VertexBufferLayout');
    }

    final arrayStride = map['arrayStride'] as int;
    final stepMode = map['stepMode'] is GPUVertexStepMode
        ? map['stepMode'] as GPUVertexStepMode
        : GPUVertexStepMode.vertex;

    final ma = map['attributes'];
    final attributes = ma is List<GPUVertexAttribute>
        ? ma
        : ma is List<Map<String, Object>>
            ? List<GPUVertexAttribute>.generate(
                ma.length, (i) => GPUVertexAttribute.fromMap(ma[i]))
            : throw Exception('Invalid attribute data for VertexBufferLayout');

    return GPUVertexBufferLayout(
        arrayStride: arrayStride, stepMode: stepMode, attributes: attributes);
  }
}
