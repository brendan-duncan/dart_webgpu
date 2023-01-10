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

typedef MapAsyncCallback = void Function();

/// A Buffer represents a block of memory that can be used in GPU operations.
/// Data is stored in linear layout, meaning that each byte of the allocation
/// can be addressed by its offset from the start of the Buffer, subject to
/// alignment restrictions depending on the operation. Some Buffers can be
/// mapped which makes the block of memory accessible via a ByteBuffer.
class Buffer extends WGpuObjectBase<wgpu.WGpuBuffer> {
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

  /// Synchronously map a buffer for read/write.
  void map({required MapMode mode, int offset = 0, int size = 0}) {
    var isMapped = false;
    mapAsync(mode: mode, offset: offset, size: size, callback: () {
      isMapped = true;
    });
    while (!isMapped) {
      // Submit an empty command buffer to flush pending commands in the queue,
      // such as the mapAsync request
      device.queue.submit();
    }
  }

  /// Asynchronously map a buffer for read/write.
  // TODO: Figure out a way to get Dart async to work with mapAsync.
  //
  // mapAsync seems to put a "pending command" into the Queue, and when the
  // buffer has been mapped, the pending command gets processed during
  // Queue.submit. Dart crashes with await for this future because it decides
  // to garbage collect all of the alive objects.
  //
  // Only the callback currently works, not the Future. If we could somehow
  // get Dart's await to call user code while waiting, we could periodically
  // submit the Queue. Or, perhaps run a pthread from C that calls queue.submit
  // while a buffer is map pending.
  Future<void> mapAsync(
      {required MapMode mode, int offset = 0, int size = 0,
        MapAsyncCallback? callback}) async {
    if (mappedState != MappedState.unmapped) {
      throw Exception('Cannot call mapAsync on a mapped buffer.');
    }

    if (size == 0) {
      size = this.size;
    }

    final completer = Completer<void>();
    _callbackData[object.cast<Void>()] = _BufferCallbackData(this, completer,
        callback);

    final cb = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Pointer<Void>, Int, Uint64,
            Uint64)>(_mapBufferCB);

    mappedState = MappedState.pending;

    libwebgpu.wgpu_buffer_map_async(
        object, cb, object.cast(), mode.value, offset, size);

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
    if (data?.callback != null) {
      data!.callback!();
    }
  }
}

class _BufferCallbackData {
  Buffer? buffer;
  Completer<void> completer;
  MapAsyncCallback? callback;

  _BufferCallbackData(this.buffer, this.completer, this.callback);
}

final _callbackData = <Pointer<Void>, _BufferCallbackData>{};
