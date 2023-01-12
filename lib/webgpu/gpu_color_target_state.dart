import '_map_util.dart';
import 'gpu_blend_state.dart';
import 'gpu_color_write.dart';
import 'gpu_texture_format.dart';

class GpuColorTargetState {
  final GpuTextureFormat format;
  final GpuBlendState? blend;
  final GpuColorWrite writeMask;

  const GpuColorTargetState(
      {required this.format, this.blend, this.writeMask = GpuColorWrite.all});

  factory GpuColorTargetState.fromMap(Map<String, Object> map) {
    final format = getMapValueRequired<GpuTextureFormat>(map['format']);
    final blend = getMapObjectNullable<GpuBlendState>(map['blend']);
    final writeMask =
        getMapValue<GpuColorWrite>(map['writeMask'], GpuColorWrite.all);

    return GpuColorTargetState(
        format: format, blend: blend, writeMask: writeMask);
  }
}
