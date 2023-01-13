import '_binding_layout_type.dart';
import '_map_util.dart';
import 'gpu_buffer_binding_type.dart';

class GPUBufferBindingLayout extends GpuBindingLayoutType {
  final GPUBufferBindingType type;
  final bool hasDynamicOffset;
  final int minBindingSize;

  const GPUBufferBindingLayout(
      {this.type = GPUBufferBindingType.uniform,
      this.hasDynamicOffset = false,
      this.minBindingSize = 0});

  factory GPUBufferBindingLayout.fromMap(Map<String, Object> map) {
    final type = mapValue<GPUBufferBindingType>(
        map['type'], GPUBufferBindingType.uniform);
    final hasDynamicOffset = mapValue<bool>(map['hasDynamicOffset'], false);
    final minBindingSize = mapValue<int>(map['minBindingSize'], 0);
    return GPUBufferBindingLayout(
        type: type,
        hasDynamicOffset: hasDynamicOffset,
        minBindingSize: minBindingSize);
  }
}
