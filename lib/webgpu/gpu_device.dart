import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import '_map_util.dart';
import 'gpu_adapter.dart';
import 'gpu_address_mode.dart';
import 'gpu_bind_group.dart';
import 'gpu_bind_group_layout.dart';
import 'gpu_buffer.dart';
import 'gpu_buffer_usage.dart';
import 'gpu_command_encoder.dart';
import 'gpu_compare_function.dart';
import 'gpu_compute_pipeline.dart';
import 'gpu_compute_pipeline_descriptor.dart';
import 'gpu_device_lost_reason.dart';
import 'gpu_error_filter.dart';
import 'gpu_error_type.dart';
import 'gpu_features.dart';
import 'gpu_filter_mode.dart';
import 'gpu_limits.dart';
import 'gpu_object.dart';
import 'gpu_pipeline_layout.dart';
import 'gpu_query_set.dart';
import 'gpu_query_type.dart';
import 'gpu_queue.dart';
import 'gpu_render_pipeline.dart';
import 'gpu_render_pipeline_descriptor.dart';
import 'gpu_sampler.dart';
import 'gpu_shader_module.dart';
import 'gpu_texture.dart';
import 'gpu_texture_dimension.dart';
import 'gpu_texture_format.dart';
import 'gpu_texture_usage.dart';

typedef ErrorCallback = void Function(
    GPUDevice device, GPUErrorType type, String message);

typedef DeviceLostCallback = void Function(
    GPUDevice device, GPUDeviceLostReason reason, String message);

class Error {
  final String message;
  const Error(this.message);
}

typedef GPUComputePipelineCallback = void Function(GPUComputePipeline p);
typedef GPURenderPipelineCallback = void Function(GPURenderPipeline p);

/// A GPUDevice is the top-level interface through which WebGPU interfaces are
/// created.
///
/// A GPUDevice is asynchronously created from an GPUAdapter through
/// GPUAdapter.requestDevice.
class GPUDevice extends GPUObjectBase<wgpu.WGpuDevice> {
  /// The [GPUAdapter] that created this GPUDevice.
  GPUAdapter adapter;

  /// The limits supported by the device (which are exactly the ones with which
  /// it was created).
  late final GPULimits limits;

  /// A set containing the GPUFeatures values of the features supported by the
  /// device (i.e. the ones with which it was created).
  late final GPUFeatures features;

  /// The default [GPUQueue] of the GPUDevice.
  late final GPUQueue queue;

  /// The lost callback will be called if the device is lost.
  final lost = <DeviceLostCallback>[];

  /// uncapturedError callbacks will be called for errors that weren't captured
  /// with pushErrorScope/popErrorScope.
  final uncapturedError = <ErrorCallback>[];

  GPUDevice(this.adapter, Pointer device) : super(device) {
    adapter.addDependent(this);
    features =
        GPUFeatures(libwebgpu.wgpu_adapter_or_device_get_features(object));
    queue = GPUQueue(this, libwebgpu.wgpu_device_get_queue(object));

    final l = calloc<wgpu.WGpuSupportedLimits>();
    libwebgpu.wgpu_adapter_or_device_get_limits(object, l);
    limits = GPULimits.fromWgpu(l);
    calloc.free(l);

    final cb = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Int, Pointer<Char>,
            Pointer<Void>)>(_deviceLostCB);

    libwebgpu.wgpu_device_set_lost_callback(object, cb, object.cast());

    _errorCallbackData[object.cast<Void>()] = _DeviceCallbackData(this);

    final fn = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Int, Pointer<Char>,
            Pointer<Void>)>(_uncapturedErrorCB);

    libwebgpu.wgpu_device_set_uncapturederror_callback(
        object, fn, object.cast());
  }

  /// Create a [GPUBuffer].
  GPUBuffer createBuffer(
          {required int size,
          required Object usage,
          bool mappedAtCreation = false}) =>
      GPUBuffer(this,
          size: size,
          usage: getMapValueRequired<GPUBufferUsage>(usage),
          mappedAtCreation: mappedAtCreation);

  /// Create a [GPUTexture]
  GPUTexture createTexture(
          {required int width,
          int height = 1,
          int depthOrArrayLayers = 1,
          required Object format,
          required Object usage,
          int mipLevelCount = 1,
          int sampleCount = 1,
          Object dimension = GPUTextureDimension.texture2d,
          List<Object>? viewFormats}) =>
      GPUTexture(this,
          width: width,
          height: height,
          depthOrArrayLayers: depthOrArrayLayers,
          mipLevelCount: mipLevelCount,
          sampleCount: sampleCount,
          dimension: getMapValueRequired<GPUTextureDimension>(dimension),
          format: getMapValueRequired<GPUTextureFormat>(format),
          usage: getMapValueRequired<GPUTextureUsage>(usage),
          viewFormats: viewFormats
              ?.map((e) => getMapValueRequired<GPUTextureFormat>(e))
              .toList());

  /// Create a [GPUSampler]
  GPUSampler createSampler(
          {Object addressModeU = GPUAddressMode.clampToEdge,
          Object addressModeV = GPUAddressMode.clampToEdge,
          Object addressModeW = GPUAddressMode.clampToEdge,
          Object magFilter = GPUFilterMode.nearest,
          Object minFilter = GPUFilterMode.nearest,
          Object mipmapFilter = GPUFilterMode.nearest,
          num lodMinClamp = 0,
          num lodMaxClamp = 32,
          Object compare = GPUCompareFunction.undefined,
          int maxAnisotropy = 1}) =>
      GPUSampler(this,
          addressModeU: getMapValueRequired<GPUAddressMode>(addressModeU),
          addressModeV: getMapValueRequired<GPUAddressMode>(addressModeV),
          addressModeW: getMapValueRequired<GPUAddressMode>(addressModeW),
          magFilter: getMapValueRequired<GPUFilterMode>(magFilter),
          minFilter: getMapValueRequired<GPUFilterMode>(minFilter),
          mipmapFilter: getMapValueRequired<GPUFilterMode>(mipmapFilter),
          lodMinClamp: lodMinClamp,
          lodMaxClamp: lodMaxClamp,
          compare: getMapValueRequired<GPUCompareFunction>(compare),
          maxAnisotropy: maxAnisotropy);

  /// Create a [GPUBindGroupLayout]
  GPUBindGroupLayout createBindGroupLayout({required List<Object> entries}) =>
      GPUBindGroupLayout(this, entries: entries);

  /// Create a [GPUPipelineLayout]
  GPUPipelineLayout createPipelineLayout(List<GPUBindGroupLayout> layouts) =>
      GPUPipelineLayout(this, layouts);

  /// Create a [GPUBindGroup]
  GPUBindGroup createBindGroup(
          {required GPUBindGroupLayout layout,
          required List<Object> entries}) =>
      GPUBindGroup(this, layout: layout, entries: entries);

  /// Create a [GPUShaderModule].
  GPUShaderModule createShaderModule({required String code}) =>
      GPUShaderModule(this, code: code);

  /// Create a [GPUComputePipeline] synchronously
  GPUComputePipeline createComputePipeline({required Object descriptor}) {
    if (descriptor is Map<String, Object>) {
      descriptor = GPUComputePipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! GPUComputePipelineDescriptor) {
      throw Exception('Invalid descriptor for createComputePipeline');
    }

    final desc = descriptor as GPUComputePipelineDescriptor;

    final entryStr = desc.entryPoint.toNativeUtf8().cast<Char>();

    final numConstants = desc.constants?.keys.length ?? 0;
    final c = malloc<wgpu.WGpuPipelineConstant>(numConstants);

    if (desc.constants != null) {
      final constants = desc.constants as Map<String, num>;
      var i = 0;
      for (final e in constants.entries) {
        final name = e.key.toNativeUtf8();
        final value = e.value.toDouble();
        c.elementAt(i).ref.name = name.cast<Char>();
        c.elementAt(i).ref.value = value;
        i++;
      }
    }

    final o = libwebgpu.wgpu_device_create_compute_pipeline(object,
        desc.module.object, entryStr, desc.layout.object, c, numConstants);

    for (var i = 0; i < numConstants; ++i) {
      malloc.free(c.elementAt(i).ref.name);
    }

    malloc.free(entryStr);
    calloc.free(c);

    return GPUComputePipeline(this, o);
  }

  /// Create a [GPURenderPipeline] synchronously.
  GPURenderPipeline createRenderPipeline({required Object descriptor}) {
    if (descriptor is Map<String, Object>) {
      descriptor = GPURenderPipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! GPURenderPipelineDescriptor) {
      throw Exception('Invalid descriptor for createRenderPipeline');
    }

    final desc = descriptor as GPURenderPipelineDescriptor;

    final d = desc.toNative();
    final o = libwebgpu.wgpu_device_create_render_pipeline(object, d);
    final pipeline = GPURenderPipeline(this, o);
    desc.deleteNative(d);
    return pipeline;
  }

  /// Create a [GPUComputePipeline] asynchronously
  /// Dart Future and await does not work yet with how WebGPU async works,
  /// so use the callback, or check the returned GPUComputePipeline.isValid
  /// property to check when the GPUComputePipeline is ready to be used.
  //Future<GPUComputePipeline> createComputePipelineAsync(
  GPUComputePipeline createComputePipelineAsync(
      {required Object descriptor,
      GPUComputePipelineCallback? callback}) /*async*/ {
    if (descriptor is Map<String, Object>) {
      descriptor = GPUComputePipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! GPUComputePipelineDescriptor) {
      throw Exception('Invalid descriptor for createComputePipeline');
    }

    final desc = descriptor as GPUComputePipelineDescriptor;

    //final completer = Completer<GPUComputePipeline>();

    final cb = Pointer.fromFunction<
        Void Function(wgpu.WGpuDevice, wgpu.WGpuPipelineBase,
            Pointer<Void>)>(_createComputePipelineCB);

    final pipeline = GPUComputePipeline(this);

    _callbackData[object.cast<Void>()] =
        _GPUComputePipelineCreationData(this, pipeline, callback);

    final entryStr = desc.entryPoint.toNativeUtf8().cast<Char>();

    final numConstants = desc.constants?.keys.length ?? 0;
    final c = malloc<wgpu.WGpuPipelineConstant>(numConstants);

    if (desc.constants != null) {
      final constants = desc.constants as Map<String, num>;
      var i = 0;
      for (final e in constants.entries) {
        final name = e.key.toNativeUtf8();
        final value = e.value.toDouble();
        c.elementAt(i).ref.name = name.cast<Char>();
        c.elementAt(i).ref.value = value;
        i++;
      }
    }

    libwebgpu.wgpu_device_create_compute_pipeline_async(
        object,
        desc.module.object,
        entryStr,
        desc.layout.object,
        c,
        numConstants,
        cb,
        object.cast());

    for (var i = 0; i < numConstants; ++i) {
      malloc.free(c.elementAt(i).ref.name);
    }
    malloc.free(entryStr);
    calloc.free(c);

    return pipeline;
    //return completer.future;
  }

  /// Create a [GPURenderPipeline] asynchronously.
  /// Dart Future and await does not work yet with how WebGPU async works,
  /// so use the callback, or check the returned GPURenderPipeline.isValid
  /// property to check when the GPURenderPipeline is ready to be used.
  //Future<GPURenderPipeline> createRenderPipelineAsync(
  GPURenderPipeline createRenderPipelineAsync(
      {required Object descriptor,
      GPURenderPipelineCallback? callback}) /*async*/ {
    if (descriptor is Map<String, Object>) {
      descriptor = GPURenderPipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! GPURenderPipelineDescriptor) {
      throw Exception('Invalid descriptor for createRenderPipelineAsync');
    }

    final desc = descriptor as GPURenderPipelineDescriptor;

    //final completer = Completer<GPURenderPipeline>();
    final pipeline = GPURenderPipeline(this);
    final d = desc.toNative();

    _callbackData[object.cast<Void>()] =
        _GPURenderPipelineCreationData(this, pipeline, callback);

    final cb = Pointer.fromFunction<
        Void Function(wgpu.WGpuDevice, wgpu.WGpuPipelineBase,
            Pointer<Void>)>(_createRenderPipelineCB);

    libwebgpu.wgpu_device_create_render_pipeline_async(
        object, d, cb, object.cast());

    desc.deleteNative(d);
    return pipeline;
    //return completer.future;
  }

  /// Create a [GPUCommandEncoder].
  GPUCommandEncoder createCommandEncoder() => GPUCommandEncoder(this);

  /// Create a [GPUQuerySet]
  GPUQuerySet createQuerySet({required Object type, required int count}) =>
      GPUQuerySet(this,
          type: getMapValueRequired<GPUQueryType>(type), count: count);

  /// Pushes a new GPU error scope onto the errorScopeStack.
  void pushErrorScope(Object filter) {
    libwebgpu.wgpu_device_push_error_scope(
        object, getMapValueRequired<GPUErrorFilter>(filter).nativeIndex);
  }

  /// Pops a GPU error scope off the errorScopeStack for this and resolves to
  /// any Error observed by the error scope, or null if none.
  void popErrorScopeAsync(ErrorCallback callback) {
    _callbackData[object.cast<Void>()] = _ErrorScopeData(this, callback);

    final fn = Pointer.fromFunction<
        Void Function(Pointer<wgpu.WGpuObjectDawn>, Int, Pointer<Char>,
            Pointer<Void>)>(_popErrorScopeCB);

    libwebgpu.wgpu_device_pop_error_scope_async(object, fn, object.cast());
  }

  static void _createComputePipelineCB(wgpu.WGpuDevice device,
      wgpu.WGpuPipelineBase pipeline, Pointer<Void> userData) {
    final data = _callbackData[userData] as _GPUComputePipelineCreationData?;
    _callbackData.remove(userData);
    //final obj = GPUComputePipeline(data!.device!, pipeline);
    data!.object.setObject(pipeline);
    if (data.callback != null) {
      data.callback!(data.object);
    }
    //data.completer.complete(obj);
  }

  static void _createRenderPipelineCB(wgpu.WGpuDevice device,
      wgpu.WGpuPipelineBase pipeline, Pointer<Void> userData) {
    final data = _callbackData[userData] as _GPURenderPipelineCreationData?;
    _callbackData.remove(userData);
    data!.object.setObject(pipeline);
    //final obj = GPURenderPipeline(data!.device!, pipeline);
    if (data.callback != null) {
      data.callback!(data.object);
    }
    //data.completer.complete(obj);
  }

  static void _popErrorScopeCB(Pointer<wgpu.WGpuObjectDawn> device, int type,
      Pointer<Char> message, Pointer<Void> userData) {
    final data = _callbackData[userData] as _ErrorScopeData?;
    _callbackData.remove(userData);
    if (data != null && data.device != null) {
      final t = type >= 0 && type < GPUErrorType.values.length
          ? GPUErrorType.values[type]
          : GPUErrorType.unknown;
      final msg = message.cast<Utf8>().toDartString();
      data.callback(data.device!, t, msg);
    }
  }

  static void _deviceLostCB(Pointer<wgpu.WGpuObjectDawn> device, int reason,
      Pointer<Char> message, Pointer<Void> userData) {
    final data = _errorCallbackData[userData];
    _callbackData.remove(userData);
    if (data != null && data.device != null) {
      final device = data.device!;
      final msg = message.cast<Utf8>().toDartString();
      final r = reason >= 0 && reason < GPUDeviceLostReason.values.length
          ? GPUDeviceLostReason.values[reason]
          : GPUDeviceLostReason.unknown;
      for (final cb in device.lost) {
        cb(device, r, msg);
      }
    }
  }

  static void _uncapturedErrorCB(Pointer<wgpu.WGpuObjectDawn> device, int type,
      Pointer<Char> message, Pointer<Void> userData) {
    final data = _errorCallbackData[userData];
    if (data != null && data.device != null) {
      final device = data.device!;
      final t = type >= 0 && type < GPUErrorType.values.length
          ? GPUErrorType.values[type]
          : GPUErrorType.unknown;
      final msg = message.cast<Utf8>().toDartString();
      for (final cb in device.uncapturedError) {
        cb(device, t, msg);
      }
      if (device.uncapturedError.isEmpty) {
        print('ERROR: $msg');
      }
    }
  }
}

class _DeviceCallbackData {
  GPUDevice? device;
  _DeviceCallbackData(this.device);
}

class _ErrorScopeData extends _DeviceCallbackData {
  ErrorCallback callback;
  _ErrorScopeData(super.device, this.callback);
}

class _GPUComputePipelineCreationData extends _DeviceCallbackData {
  //Completer<GPUComputePipeline> completer;
  GPUComputePipeline object;
  GPUComputePipelineCallback? callback;
  _GPUComputePipelineCreationData(super.device, this.object, this.callback);
}

class _GPURenderPipelineCreationData extends _DeviceCallbackData {
  //Completer<GPURenderPipeline> completer;
  GPURenderPipeline object;
  GPURenderPipelineCallback? callback;
  _GPURenderPipelineCreationData(super.device, this.object, this.callback);
}

final _callbackData = <Pointer<Void>, _DeviceCallbackData>{};
final _errorCallbackData = <Pointer<Void>, _DeviceCallbackData>{};
