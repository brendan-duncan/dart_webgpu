import 'shader_module.dart';
import 'vertex_buffer_layout.dart';

class VertexState {
  final ShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;
  final List<VertexBufferLayout>? buffers;

  const VertexState(
      {required this.module,
      required this.entryPoint,
      this.constants,
      this.buffers});
}
