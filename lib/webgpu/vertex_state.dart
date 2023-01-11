import 'shader_module.dart';
import 'vertex_buffer_layout.dart';

class VertexState {
  final ShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;
  final List<VertexBufferLayout>? buffers;

  factory VertexState.fromMap(Map<String, Object> map) {
    if (map['module'] is! ShaderModule || map['entryPoint'] is! String) {
      throw Exception('Invalid Data for VertexState');
    }

    final constants = map['constants'] is Map<String, num>
        ? map['constants'] as Map<String, num>
        : null;

    final mb = map['buffers'];
    final buffers = mb is List<VertexBufferLayout>
        ? mb
        : mb is List<Map<String, Object>>
            ? List<VertexBufferLayout>.generate(
                mb.length, (index) => VertexBufferLayout.fromMap(mb[index]))
            : null;

    return VertexState(
        module: map['module'] as ShaderModule,
        entryPoint: map['entryPoint'] as String,
        constants: constants,
        buffers: buffers);
  }

  const VertexState(
      {required this.module,
      required this.entryPoint,
      this.constants,
      this.buffers});
}
