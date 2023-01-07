import 'dart:async';
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
import 'compute_pipeline.dart';
import 'device_lost_info.dart';
import 'error_filter.dart';
import 'error_type.dart';
import 'features.dart';
import 'limits.dart';
import 'pipeline_layout.dart';
import 'queue.dart';
import 'shader_module.dart';
import 'wgpu_object.dart';

typedef ErrorCallback = void Function(
    Device device, ErrorType type, String message);

class Error {
  final String message;
  const Error(this.message);
}

/// A Device is the top-level interface through which WebGPU interfaces are
/// created. A Device is asynchronously created from an Adapter through the
/// Adapter.requestDevice method.
class Device extends WGpuObject<wgpu.WGpuDevice> {
  Adapter adapter;
  late final Limits limits;
  late final Features features;
  late final Queue queue;
  final Completer<DeviceLostInfo> _lost;
  final uncapturedError = <ErrorCallback>[];

  Device(this.adapter, Pointer device)
    : _lost = Completer<DeviceLostInfo>()
    , super(device) {
    adapter.addDependent(this);
    features = Features(libwebgpu.wgpu_adapter_or_device_get_features(object));
    queue = Queue(this, libwebgpu.wgpu_device_get_queue(object));

    final l = calloc<wgpu.WGpuSupportedLimits>();
    libwebgpu.wgpu_adapter_or_device_get_limits(object, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);

    final cb = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Int,
            Pointer<Char>, Pointer<Void>)>(_deviceLostCB);

    libwebgpu.wgpu_device_set_lost_callback(object, cb, object.cast());

    _errorCallbackData[object.cast<Void>()] = _DeviceCallbackData(this);

    final fn = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Int, Pointer<Char>,
            Pointer<Void>)>(_uncapturedErrorCB);

    libwebgpu.wgpu_device_set_uncapturederror_callback(object, fn,
        object.cast());
  }

  /// The lost Future will resolve if the device is lost.
  Future<DeviceLostInfo> get lost => _lost.future;

  /// Create a [ShaderModule].
  ShaderModule createShaderModule({required String code}) =>
      ShaderModule(this, code: code);

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

  /// Create a [PipelineLayout]
  PipelineLayout createPipelineLayout(List<BindGroupLayout> layouts) =>
    PipelineLayout(this, layouts);

  /// Create a [ComputePipeline] synchronously
  ComputePipeline createComputePipeline(
      {required PipelineLayout layout,
        required ShaderModule module,
        required String entryPoint,
        List<Map<String,num>>? constants}) {

    final entryStr = entryPoint.toNativeUtf8().cast<Char>();

    final sizeofConstant = sizeOf<wgpu.WGpuPipelineConstant>();
    final numConstants = constants?.length ?? 0;
    final constantsBuffer = malloc<wgpu.WGpuPipelineConstant>(
        numConstants * sizeofConstant);

    final o = libwebgpu.wgpu_device_create_compute_pipeline(object,
        module.object, entryStr, layout.object, constantsBuffer, numConstants);

    malloc.free(entryStr);

    return ComputePipeline(this, o);
  }

  /// Create a [ComputePipeline] asynchronously
  Future<ComputePipeline> createComputePipelineAsync(
      {required PipelineLayout layout,
        required ShaderModule module,
        required String entryPoint,
        List<Map<String,num>>? constants}) async {
    final completer = Completer<ComputePipeline>();

    final cb = Pointer.fromFunction<
        Void Function(wgpu.WGpuDevice, wgpu.WGpuPipelineBase,
          Pointer<Void>)>(_createComputePipelineCB);

    final entryStr = entryPoint.toNativeUtf8().cast<Char>();

    final sizeofConstant = sizeOf<wgpu.WGpuPipelineConstant>();
    final numConstants = constants?.length ?? 0;
    final constantsBuffer = malloc<wgpu.WGpuPipelineConstant>(
        numConstants * sizeofConstant);

    _callbackData[object.cast<Void>()] = _ComputePipelineCreationData(this,
        completer);

    libwebgpu.wgpu_device_create_compute_pipeline_async(object,
      module.object, entryStr, layout.object, constantsBuffer, numConstants,
        cb, object.cast());

    malloc.free(entryStr);

    return completer.future;
  }

  static void _createComputePipelineCB(wgpu.WGpuDevice device,
      wgpu.WGpuPipelineBase pipeline, Pointer<Void> userData) {
    final data = _callbackData[userData] as _ComputePipelineCreationData?;
    _callbackData.remove(userData);
    final obj = ComputePipeline(data!.device!, pipeline);
    data.completer.complete(obj);
  }

  /// Create a [CommandEncoder].
  CommandEncoder createCommandEncoder() => CommandEncoder(this);

  void pushErrorScope(ErrorFilter filter) {
    libwebgpu.wgpu_device_push_error_scope(object, filter.index);
  }

  void popErrorScopeAsync(ErrorCallback callback) {
    _callbackData[object.cast<Void>()] = _ErrorScopeData(this, callback);

    final fn = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Int, Pointer<Char>,
            Pointer<Void>)>(_popErrorScopeCB);

    libwebgpu.wgpu_device_pop_error_scope_async(object, fn, object.cast());
  }

  static void _popErrorScopeCB(Pointer<wgpu.WGpuObjectDawn> device, int type,
      Pointer<Char> message, Pointer<Void> userData) {
    final data = _callbackData[userData] as _ErrorScopeData?;
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

  static void _deviceLostCB(Pointer<wgpu.WGpuObjectDawn> device, int reason,
      Pointer<Char> message, Pointer<Void> userData) {
    final data = _callbackData[userData];
    _callbackData.remove(userData);
    calloc.free(userData);
    if (data != null) {
      final msg = message.cast<Utf8>().toDartString();
      final rsn = reason >= 0 && reason < DeviceLostReason.values.length ?
          DeviceLostReason.values[reason] : DeviceLostReason.unknown;
      data.device?._lost.complete(DeviceLostInfo(msg, rsn));
    }
  }

  static void _uncapturedErrorCB(Pointer<wgpu.WGpuObjectDawn> device, int type,
      Pointer<Char> message, Pointer<Void> userData) {
    final data = _errorCallbackData[userData];
    if (data != null && data.device != null) {
      final device = data.device!;
      final t = type >= 0 && type < ErrorType.values.length
          ? ErrorType.values[type]
          : ErrorType.unknown;
      final msg = message.cast<Utf8>().toDartString();
      for (final cb in device.uncapturedError) {
        cb(device, t, msg);
      }
    }
  }
}

class _DeviceCallbackData {
  Device? device;
  _DeviceCallbackData(this.device);
}

class _ErrorScopeData extends _DeviceCallbackData {
  ErrorCallback callback;
  _ErrorScopeData(super.device, this.callback);
}

class _ComputePipelineCreationData extends _DeviceCallbackData {
  Completer<ComputePipeline> completer;
  _ComputePipelineCreationData(super.device, this.completer);
}

final _callbackData = <Pointer<Void>, _DeviceCallbackData>{};
final _errorCallbackData = <Pointer<Void>, _DeviceCallbackData>{};
