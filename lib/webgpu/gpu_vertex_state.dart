import 'gpu_shader_module.dart';
import 'gpu_vertex_buffer_layout.dart';

class GPUVertexState {
  final GPUShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;
  final List<GPUVertexBufferLayout>? buffers;

  factory GPUVertexState.fromMap(Map<String, Object> map) {
    if (map['module'] is! GPUShaderModule || map['entryPoint'] is! String) {
      throw Exception('Invalid Data for VertexState');
    }

    final constants = map['constants'] is Map<String, num>
        ? map['constants'] as Map<String, num>
        : null;

    final mb = map['buffers'];
    final buffers = mb is List<GPUVertexBufferLayout>
        ? mb
        : mb is List<Map<String, Object>>
            ? List<GPUVertexBufferLayout>.generate(
                mb.length, (index) => GPUVertexBufferLayout.fromMap(mb[index]))
            : null;

    return GPUVertexState(
        module: map['module'] as GPUShaderModule,
        entryPoint: map['entryPoint'] as String,
        constants: constants,
        buffers: buffers);
  }

  const GPUVertexState(
      {required this.module,
      required this.entryPoint,
      this.constants,
      this.buffers});
}
