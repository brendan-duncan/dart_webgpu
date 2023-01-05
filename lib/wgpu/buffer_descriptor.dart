import 'buffer_usage_flags.dart';

class BufferDescriptor {
  int size;
  BufferUsageFlags usage;
  bool mappedAtCreation;

  BufferDescriptor(this.size, this.usage, this.mappedAtCreation);
}
