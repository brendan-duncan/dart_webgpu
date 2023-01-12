import 'gpu_shader_module.dart';
import 'gpu_vertex_buffer_layout.dart';

class GpuVertexState {
  final GpuShaderModule module;
  final String entryPoint;
  final Map<String, num>? constants;
  final List<GpuVertexBufferLayout>? buffers;

  factory GpuVertexState.fromMap(Map<String, Object> map) {
    if (map['module'] is! GpuShaderModule || map['entryPoint'] is! String) {
      throw Exception('Invalid Data for VertexState');
    }

    final constants = map['constants'] is Map<String, num>
        ? map['constants'] as Map<String, num>
        : null;

    final mb = map['buffers'];
    final buffers = mb is List<GpuVertexBufferLayout>
        ? mb
        : mb is List<Map<String, Object>>
            ? List<GpuVertexBufferLayout>.generate(
                mb.length, (index) => GpuVertexBufferLayout.fromMap(mb[index]))
            : null;

    return GpuVertexState(
        module: map['module'] as GpuShaderModule,
        entryPoint: map['entryPoint'] as String,
        constants: constants,
        buffers: buffers);
  }

  const GpuVertexState(
      {required this.module,
      required this.entryPoint,
      this.constants,
      this.buffers});
}
