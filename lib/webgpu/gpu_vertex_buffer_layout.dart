import 'gpu_vertex_attribute.dart';
import 'gpu_vertex_step_mode.dart';

class GpuVertexBufferLayout {
  final int arrayStride;
  final GpuVertexStepMode stepMode;
  final List<GpuVertexAttribute> attributes;

  const GpuVertexBufferLayout(
      {required this.arrayStride,
      this.stepMode = GpuVertexStepMode.vertex,
      required this.attributes});

  factory GpuVertexBufferLayout.fromMap(Map<String, Object> map) {
    if (map['arrayStride'] is! int || map['attributes'] is! List) {
      throw Exception('Invalid data for VertexBufferLayout');
    }

    final arrayStride = map['arrayStride'] as int;
    final stepMode = map['stepMode'] is GpuVertexStepMode
        ? map['stepMode'] as GpuVertexStepMode
        : GpuVertexStepMode.vertex;

    final ma = map['attributes'];
    final attributes = ma is List<GpuVertexAttribute>
        ? ma
        : ma is List<Map<String, Object>>
            ? List<GpuVertexAttribute>.generate(
                ma.length, (i) => GpuVertexAttribute.fromMap(ma[i]))
            : throw Exception('Invalid attribute data for VertexBufferLayout');

    return GpuVertexBufferLayout(
        arrayStride: arrayStride, stepMode: stepMode, attributes: attributes);
  }
}
