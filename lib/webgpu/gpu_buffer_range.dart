import 'dart:ffi';
import 'dart:typed_data';

import 'gpu_buffer.dart';

class GpuBufferRange {
  final GpuBuffer buffer;
  final int offset;
  final int size;
  final Pointer<Uint8> data;
  final Uint8List _byteBuffer;

  GpuBufferRange(this.buffer, this.offset, this.size, this.data)
      : _byteBuffer = data.asTypedList(size);

  T as<T extends TypedData>() {
    final b = _byteBuffer.buffer;
    if (T == ByteData) {
      return ByteData.view(b, 0, size) as T;
    }
    if (T == Float32List) {
      return Float32List.view(b, 0, size ~/ Float32List.bytesPerElement) as T;
    }
    if (T == Float32x4List) {
      return Float32x4List.view(b, 0, size ~/ Float32x4List.bytesPerElement)
          as T;
    }
    if (T == Float64List) {
      return Float64List.view(b, 0, size ~/ Float64List.bytesPerElement) as T;
    }
    if (T == Float64x2List) {
      return Float64x2List.view(b, 0, size ~/ Float64x2List.bytesPerElement)
          as T;
    }
    if (T == Int8List) {
      return Int8List.view(b, 0, size) as T;
    }
    if (T == Int16List) {
      return Int16List.view(b, 0, size ~/ Int16List.bytesPerElement) as T;
    }
    if (T == Int32List) {
      return Int32List.view(b, 0, size ~/ Int32List.bytesPerElement) as T;
    }
    if (T == Int32x4List) {
      return Int32x4List.view(b, 0, size ~/ Int32x4List.bytesPerElement) as T;
    }
    if (T == Int64List) {
      return Int64List.view(b, 0, size ~/ Int64List.bytesPerElement) as T;
    }
    if (T == Uint8ClampedList) {
      return Uint8ClampedList.view(b, 0, size) as T;
    }
    if (T == Uint8List) {
      return Uint8List.view(b, 0, size) as T;
    }
    if (T == Uint16List) {
      return Uint16List.view(b, 0, size ~/ Uint16List.bytesPerElement) as T;
    }
    if (T == Uint32List) {
      return Uint32List.view(b, 0, size ~/ Uint32List.bytesPerElement) as T;
    }
    if (T == Uint64List) {
      return Uint64List.view(b, 0, size ~/ Uint64List.bytesPerElement) as T;
    }

    return Uint8List.view(b, 0, size) as T;
  }
}
