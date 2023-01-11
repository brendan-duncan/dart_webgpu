import 'vertex_attribute.dart';
import 'vertex_step_mode.dart';

class VertexBufferLayout {
  final int arrayStride;
  final VertexStepMode stepMode;
  final List<VertexAttribute> attributes;

  const VertexBufferLayout(
      {required this.arrayStride,
      this.stepMode = VertexStepMode.vertex,
      required this.attributes});

  factory VertexBufferLayout.fromMap(Map<String, Object> map) {
    if (map['arrayStride'] is! int || map['attributes'] is! List) {
      throw Exception('Invalid data for VertexBufferLayout');
    }

    final arrayStride = map['arrayStride'] as int;
    final stepMode = map['stepMode'] is VertexStepMode
        ? map['stepMode'] as VertexStepMode
        : VertexStepMode.vertex;

    final ma = map['attributes'];
    final attributes = ma is List<VertexAttribute>
        ? ma
        : ma is List<Map<String, Object>>
            ? List<VertexAttribute>.generate(
                ma.length, (i) => VertexAttribute.fromMap(ma[i]))
            : throw Exception('Invalid attribute data for VertexBufferLayout');

    return VertexBufferLayout(
        arrayStride: arrayStride, stepMode: stepMode, attributes: attributes);
  }
}
