import '_binding_layout_type.dart';
import '_map_util.dart';
import 'buffer_binding_type.dart';

class BufferBindingLayout extends BindingLayoutType {
  final BufferBindingType type;
  final bool hasDynamicOffset;
  final int minBindingSize;

  const BufferBindingLayout(
      {this.type = BufferBindingType.uniform,
      this.hasDynamicOffset = false,
      this.minBindingSize = 0});

  factory BufferBindingLayout.fromMap(Map<String, Object> map) {
    final type =
        getMapValue<BufferBindingType>(map['type'], BufferBindingType.uniform);
    final hasDynamicOffset = getMapValue<bool>(map['hasDynamicOffset'], false);
    final minBindingSize = getMapValue<int>(map['minBindingSize'], 0);
    return BufferBindingLayout(
        type: type,
        hasDynamicOffset: hasDynamicOffset,
        minBindingSize: minBindingSize);
  }
}
