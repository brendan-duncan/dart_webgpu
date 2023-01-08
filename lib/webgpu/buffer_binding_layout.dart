import '_binding_layout_type.dart';
import 'buffer_binding_type.dart';

class BufferBindingLayout extends BindingLayoutType {
  final BufferBindingType type;
  final bool hasDynamicOffset;
  final int minBindingSize;

  const BufferBindingLayout({ this.type = BufferBindingType.uniform,
    this.hasDynamicOffset = false, this.minBindingSize = 0});
}
