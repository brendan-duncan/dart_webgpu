import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'adapter.dart';
import 'bind_group.dart';
import 'bind_group_layout.dart';
import 'buffer.dart';
import 'buffer_usage.dart';
import 'command_encoder.dart';
import 'error_filter.dart';
import 'error_type.dart';
import 'features.dart';
import 'limits.dart';
import 'queue.dart';
import 'shader_module.dart';
import 'wgpu_object.dart';

typedef ErrorScopeCallback = void Function(
    Device device, ErrorType type, String message);

/// A Device is the top-level interface through which WebGPU interfaces are
/// created. A Device is asynchronously created from an Adapter through the
/// Adapter.requestDevice method.
class Device extends WGpuObject<wgpu.WGpuDevice> {
  Adapter adapter;
  late final Limits limits;
  late final Features features;
  late final Queue queue;

  Device(this.adapter, Pointer device) : super(device) {
    adapter.addDependent(this);
    features = Features(libwebgpu.wgpu_adapter_or_device_get_features(object));
    queue = Queue(this, libwebgpu.wgpu_device_get_queue(object));

    final l = calloc<wgpu.WGpuSupportedLimits>();
    libwebgpu.wgpu_adapter_or_device_get_limits(object, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);
  }

  /// Create a [ShaderModule].
  ShaderModule createShaderModule(
          {required String
              code /*, Map<String, wgpu.WGpuPipelineLayout>? hints*/}) =>
      ShaderModule(this, code: code); //, hints: hints);

  /// Create a [Buffer].
  Buffer createBuffer(
          {required int size,
          required BufferUsage usage,
          bool mappedAtCreation = false}) =>
      Buffer(this,
          size: size, usage: usage, mappedAtCreation: mappedAtCreation);

  /// Create a [BindGroupLayout]
  BindGroupLayout createBindGroupLayout(
          {required List<Map<String, Object>> entries}) =>
      BindGroupLayout(this, entries: entries);

  /// Create a [BindGroup]
  BindGroup createBindGroup(
          {required BindGroupLayout layout,
          required List<Map<String, Object>> entries}) =>
      BindGroup(this, layout: layout, entries: entries);

  /// Create a [CommandEncoder].
  CommandEncoder createCommandEncoder() => CommandEncoder(this);

  void pushErrorScope(ErrorFilter filter) {
    libwebgpu.wgpu_device_push_error_scope(object, filter.index);
  }

  void popErrorScopeAsync(ErrorScopeCallback callback) {
    _callbackData[object.cast<Void>()] = _DeviceCallbackData(this, callback);

    final fn = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Int, Pointer<Char>,
            Pointer<Void>)>(_popErrorScopeCB);

    libwebgpu.wgpu_device_pop_error_scope_async(object, fn, object.cast());
  }

  static void _popErrorScopeCB(Pointer<wgpu.WGpuObjectDawn> device, int type,
      Pointer<Char> message, Pointer<Void> userData) {
    final data = _callbackData[userData];
    _callbackData.remove(userData);
    calloc.free(userData);
    if (data != null && data.device != null) {
      final t = type >= 0 && type < ErrorType.values.length
          ? ErrorType.values[type]
          : ErrorType.unknown;
      final msg = message.cast<Utf8>().toDartString();
      data.callback(data.device!, t, msg);
    }
  }
}

class _DeviceCallbackData {
  Device? device;
  ErrorScopeCallback callback;
  _DeviceCallbackData(this.device, this.callback);
}

final _callbackData = <Pointer<Void>, _DeviceCallbackData>{};
