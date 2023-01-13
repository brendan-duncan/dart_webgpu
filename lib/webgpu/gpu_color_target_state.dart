import '_map_util.dart';
import 'gpu_blend_state.dart';
import 'gpu_color_write.dart';
import 'gpu_texture_format.dart';

class GpuColorTargetState {
  final GPUTextureFormat format;
  final GPUBlendState? blend;
  final GPUColorWrite writeMask;

  const GpuColorTargetState(
      {required this.format, this.blend, this.writeMask = GPUColorWrite.all});

  factory GpuColorTargetState.fromMap(Map<String, Object> map) {
    final format = mapValueRequired<GPUTextureFormat>(map['format']);
    final blend = mapObjectNullable<GPUBlendState>(map['blend']);
    final writeMask =
        mapValue<GPUColorWrite>(map['writeMask'], GPUColorWrite.all);

    return GpuColorTargetState(
        format: format, blend: blend, writeMask: writeMask);
  }
}
