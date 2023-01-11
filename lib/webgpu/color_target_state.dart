import '_map_util.dart';
import 'blend_state.dart';
import 'color_write.dart';
import 'texture_format.dart';

class ColorTargetState {
  final TextureFormat format;
  final BlendState? blend;
  final ColorWrite writeMask;

  const ColorTargetState(
      {required this.format, this.blend, this.writeMask = ColorWrite.all});

  factory ColorTargetState.fromMap(Map<String, Object> map) {
    final format = getMapValueRequired<TextureFormat>(map, 'format');
    final b = map['blend'];
    final blend = b is BlendState
        ? b
        : b is Map<String, Object>
            ? BlendState.fromMap(b)
            : null;
    final writeMask = getMapValue<ColorWrite>(map, 'writeMask', ColorWrite.all);

    return ColorTargetState(format: format, blend: blend, writeMask: writeMask);
  }
}
