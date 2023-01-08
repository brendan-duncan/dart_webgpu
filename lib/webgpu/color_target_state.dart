import 'blend_state.dart';
import 'color_write.dart';
import 'texture_format.dart';

class ColorTargetState {
  final TextureFormat format;
  final BlendState? blend;
  final ColorWrite writeMask;
  const ColorTargetState(
      {required this.format, this.blend, this.writeMask = ColorWrite.all});
}
