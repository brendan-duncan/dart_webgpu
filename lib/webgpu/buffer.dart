import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'buffer_range.dart';
import 'buffer_usage.dart';
import 'device.dart';
import 'map_mode.dart';
import 'mapped_state.dart';
import 'wgpu_object.dart';

/// A Buffer represents a block of memory that can be used in GPU operations.
/// Data is stored in linear layout, meaning that each byte of the allocation
/// can be addressed by its offset from the start of the Buffer, subject to
/// alignment restrictions depending on the operation. Some Buffers can be
/// mapped which makes the block of memory accessible via a ByteBuffer.
class Buffer extends WGpuObject<wgpu.WGpuBuffer> {
  /// The Device that owns this Buffer.
  final Device device;

  /// The size in bytes of the Buffer.
  final int size;

  /// How the Buffer is intended to be used.
  final BufferUsage usage;

  /// If mappedState is MappedState.mapped, the Buffer memory is accessible
  /// from the getMappedRange method. If it is MappedState.unmapped, the
  /// Buffer memory is only accessible from the GPU. Mapping is asynchronous,
  /// and if the mapping state was changed but has not been completed yet,
  /// it will be MappedState.pending.
  late MappedState mappedState;

  Buffer(this.device,
      {required this.size,
      required this.usage,
      bool mappedAtCreation = false}) {
    final p = calloc<wgpu.WGpuBufferDescriptor>();

    p.ref.size = size;
    p.ref.usage = usage.value;
    p.ref.mappedAtCreation = mappedAtCreation ? 1 : 0;

    final obj = libwebgpu.wgpu_device_create_buffer(device.object, p);
    setObject(obj);
    device.addDependent(this);

    if (obj != nullptr && mappedAtCreation) {
      mappedState = MappedState.mapped;
    } else {
      mappedState = MappedState.unmapped;
    }

    calloc.free(p);
  }

  BufferRange getMappedRange({int startOffset = 0, int size = 0}) {
    if (mappedState == MappedState.unmapped ||
        mappedState == MappedState.pending) {
      throw Exception('Cannot call getMappedRange on an unmapped buffer.');
    }
    if (size == 0) {
      size = this.size;
    }

    final p =
        libwebgpu.wgpu_buffer_get_mapped_range_dart(object, startOffset, size);

    if (p == nullptr) {
      throw Exception('Unable to get mapped range from buffer.');
    }

    return BufferRange(this, startOffset, size, p.cast<Uint8>());
  }

  Future<void> mapAsync(
      {required MapMode mode, int offset = 0, int size = 0}) async {
    if (mappedState != MappedState.unmapped) {
      throw Exception('Cannot call mapAsync on a mapped buffer.');
    }

    if (size == 0) {
      size = this.size;
    }

    final completer = Completer<void>();
    _callbackData[object.cast<Void>()] = _BufferCallbackData(this, completer);

    final cb = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Pointer<Void>, Int, Uint64,
            Uint64)>(_mapBufferCB);

    mappedState = MappedState.pending;
    libwebgpu.wgpu_buffer_map_async(
        object, cb, object.cast(), mode.nativeIndex, offset, size);

    return completer.future;
  }

  void unmap() {
    if (mappedState == MappedState.mapped) {
      libwebgpu.wgpu_buffer_unmap(object);
      mappedState = MappedState.unmapped;
    }
  }

  @override
  String toString() =>
      'Buffer(size: $size, usage: $usage, mappedState: $mappedState)';

  static void _mapBufferCB(Pointer<wgpu.WGpuObjectDawn> buffer,
      Pointer<Void> userData, int mode, int offset, int size) {
    final data = _callbackData[userData];
    _callbackData.remove(userData);
    data?.buffer?.mappedState = MappedState.mapped;
    data?.completer.complete();
  }
}

class _BufferCallbackData {
  Buffer? buffer;
  Completer<void> completer;

  _BufferCallbackData(this.buffer, this.completer);
}

final _callbackData = <Pointer<Void>, _BufferCallbackData>{};
