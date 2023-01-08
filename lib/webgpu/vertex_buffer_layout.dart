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
}
