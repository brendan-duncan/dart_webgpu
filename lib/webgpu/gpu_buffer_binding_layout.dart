import '_binding_layout_type.dart';
import '_map_util.dart';
import 'gpu_buffer_binding_type.dart';

class GpuBufferBindingLayout extends GpuBindingLayoutType {
  final GpuBufferBindingType type;
  final bool hasDynamicOffset;
  final int minBindingSize;

  const GpuBufferBindingLayout(
      {this.type = GpuBufferBindingType.uniform,
      this.hasDynamicOffset = false,
      this.minBindingSize = 0});

  factory GpuBufferBindingLayout.fromMap(Map<String, Object> map) {
    final type = getMapValue<GpuBufferBindingType>(
        map['type'], GpuBufferBindingType.uniform);
    final hasDynamicOffset = getMapValue<bool>(map['hasDynamicOffset'], false);
    final minBindingSize = getMapValue<int>(map['minBindingSize'], 0);
    return GpuBufferBindingLayout(
        type: type,
        hasDynamicOffset: hasDynamicOffset,
        minBindingSize: minBindingSize);
  }
}
