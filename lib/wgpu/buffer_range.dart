import 'dart:typed_data';

import 'buffer.dart';

class BufferRange {
  final Buffer buffer;
  final int startOffset;
  final int size;
  final Uint8List data;

  BufferRange(this.buffer, this.startOffset, this.size)
      : data = Uint8List(size);
}
