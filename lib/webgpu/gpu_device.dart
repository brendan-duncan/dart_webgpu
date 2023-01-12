import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
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
    GpuDevice device, GpuErrorType type, String message);

typedef DeviceLostCallback = void Function(
    GpuDevice device, GpuDeviceLostReason reason, String message);

class Error {
  final String message;
  const Error(this.message);
}

typedef GpuComputePipelineCallback = void Function(GpuComputePipeline p);
typedef GpuRenderPipelineCallback = void Function(GpuRenderPipeline p);

/// A GpuDevice is the top-level interface through which WebGPU interfaces are
/// created.
///
/// A GpuDevice is asynchronously created from an GpuAdapter through
/// GpuAdapter.requestDevice.
class GpuDevice extends GpuObjectBase<wgpu.WGpuDevice> {
  /// The [GpuAdapter] that created this GpuDevice.
  GpuAdapter adapter;

  /// The limits supported by the device (which are exactly the ones with which
  /// it was created).
  late final GpuLimits limits;

  /// A set containing the GpuFeatures values of the features supported by the
  /// device (i.e. the ones with which it was created).
  late final GpuFeatures features;

  /// The default [GpuQueue] of the GpuDevice.
  late final GpuQueue queue;

  /// The lost callback will be called if the device is lost.
  final lost = <DeviceLostCallback>[];

  /// uncapturedError callbacks will be called for errors that weren't captured
  /// with pushErrorScope/popErrorScope.
  final uncapturedError = <ErrorCallback>[];

  GpuDevice(this.adapter, Pointer device) : super(device) {
    adapter.addDependent(this);
    features =
        GpuFeatures(libwebgpu.wgpu_adapter_or_device_get_features(object));
    queue = GpuQueue(this, libwebgpu.wgpu_device_get_queue(object));

    final l = calloc<wgpu.WGpuSupportedLimits>();
    libwebgpu.wgpu_adapter_or_device_get_limits(object, l);
    limits = GpuLimits.fromWgpu(l);
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

  /// Create a [GpuBuffer].
  GpuBuffer createBuffer(
          {required int size,
          required GpuBufferUsage usage,
          bool mappedAtCreation = false}) =>
      GpuBuffer(this,
          size: size, usage: usage, mappedAtCreation: mappedAtCreation);

  /// Create a [GpuTexture]
  GpuTexture createTexture(
          {required int width,
          int height = 1,
          int depthOrArrayLayers = 1,
          required GpuTextureFormat format,
          required GpuTextureUsage usage,
          int mipLevelCount = 1,
          int sampleCount = 1,
          GpuTextureDimension dimension = GpuTextureDimension.texture2d,
          List<GpuTextureFormat>? viewFormats}) =>
      GpuTexture(this,
          width: width,
          height: height,
          depthOrArrayLayers: depthOrArrayLayers,
          mipLevelCount: mipLevelCount,
          sampleCount: sampleCount,
          dimension: dimension,
          format: format,
          usage: usage,
          viewFormats: viewFormats);

  /// Create a [GpuSampler]
  GpuSampler createSampler(
          {GpuAddressMode addressModeU = GpuAddressMode.clampToEdge,
          GpuAddressMode addressModeV = GpuAddressMode.clampToEdge,
          GpuAddressMode addressModeW = GpuAddressMode.clampToEdge,
          GpuFilterMode magFilter = GpuFilterMode.nearest,
          GpuFilterMode minFilter = GpuFilterMode.nearest,
          GpuFilterMode mipmapFilter = GpuFilterMode.nearest,
          num lodMinClamp = 0,
          num lodMaxClamp = 32,
          GpuCompareFunction compare = GpuCompareFunction.undefined,
          int maxAnisotropy = 1}) =>
      GpuSampler(this,
          addressModeU: addressModeU,
          addressModeV: addressModeV,
          addressModeW: addressModeW,
          magFilter: magFilter,
          minFilter: minFilter,
          mipmapFilter: mipmapFilter,
          lodMinClamp: lodMinClamp,
          lodMaxClamp: lodMaxClamp,
          compare: compare,
          maxAnisotropy: maxAnisotropy);

  /// Create a [GpuBindGroupLayout]
  GpuBindGroupLayout createBindGroupLayout(
          {required List<Object> entries}) =>
      GpuBindGroupLayout(this, entries: entries);

  /// Create a [GpuPipelineLayout]
  GpuPipelineLayout createPipelineLayout(List<GpuBindGroupLayout> layouts) =>
      GpuPipelineLayout(this, layouts);

  /// Create a [GpuBindGroup]
  GpuBindGroup createBindGroup(
          {required GpuBindGroupLayout layout,
          required List<Object> entries}) =>
      GpuBindGroup(this, layout: layout, entries: entries);

  /// Create a [GpuShaderModule].
  GpuShaderModule createShaderModule({required String code}) =>
      GpuShaderModule(this, code: code);

  /// Create a [GpuComputePipeline] synchronously
  GpuComputePipeline createComputePipeline({required Object descriptor}) {
    if (descriptor is Map<String, Object>) {
      descriptor = GpuComputePipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! GpuComputePipelineDescriptor) {
      throw Exception('Invalid descriptor for createComputePipeline');
    }

    final desc = descriptor as GpuComputePipelineDescriptor;

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

    return GpuComputePipeline(this, o);
  }

  /// Create a [GpuRenderPipeline] synchronously.
  GpuRenderPipeline createRenderPipeline({required Object descriptor}) {
    if (descriptor is Map<String, Object>) {
      descriptor = GpuRenderPipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! GpuRenderPipelineDescriptor) {
      throw Exception('Invalid descriptor for createRenderPipeline');
    }

    final desc = descriptor as GpuRenderPipelineDescriptor;

    final d = desc.toNative();
    final o = libwebgpu.wgpu_device_create_render_pipeline(object, d);
    final pipeline = GpuRenderPipeline(this, o);
    desc.deleteNative(d);
    return pipeline;
  }

  /// Create a [GpuComputePipeline] asynchronously
  /// Dart Future and await does not work yet with how WebGPU async works,
  /// so use the callback, or check the returned GpuComputePipeline.isValid
  /// property to check when the GpuComputePipeline is ready to be used.
  //Future<GpuComputePipeline> createComputePipelineAsync(
  GpuComputePipeline createComputePipelineAsync(
      {required Object descriptor,
      GpuComputePipelineCallback? callback}) /*async*/ {
    if (descriptor is Map<String, Object>) {
      descriptor = GpuComputePipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! GpuComputePipelineDescriptor) {
      throw Exception('Invalid descriptor for createComputePipeline');
    }

    final desc = descriptor as GpuComputePipelineDescriptor;

    //final completer = Completer<GpuComputePipeline>();

    final cb = Pointer.fromFunction<
        Void Function(wgpu.WGpuDevice, wgpu.WGpuPipelineBase,
            Pointer<Void>)>(_createComputePipelineCB);

    final pipeline = GpuComputePipeline(this);

    _callbackData[object.cast<Void>()] =
        _GpuComputePipelineCreationData(this, pipeline, callback);

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

  /// Create a [GpuRenderPipeline] asynchronously.
  /// Dart Future and await does not work yet with how WebGPU async works,
  /// so use the callback, or check the returned GpuRenderPipeline.isValid
  /// property to check when the GpuRenderPipeline is ready to be used.
  //Future<GpuRenderPipeline> createRenderPipelineAsync(
  GpuRenderPipeline createRenderPipelineAsync(
      {required Object descriptor,
      GpuRenderPipelineCallback? callback}) /*async*/ {
    if (descriptor is Map<String, Object>) {
      descriptor = GpuRenderPipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! GpuRenderPipelineDescriptor) {
      throw Exception('Invalid descriptor for createRenderPipelineAsync');
    }

    final desc = descriptor as GpuRenderPipelineDescriptor;

    //final completer = Completer<GpuRenderPipeline>();
    final pipeline = GpuRenderPipeline(this);
    final d = desc.toNative();

    _callbackData[object.cast<Void>()] =
        _GpuRenderPipelineCreationData(this, pipeline, callback);

    final cb = Pointer.fromFunction<
        Void Function(wgpu.WGpuDevice, wgpu.WGpuPipelineBase,
            Pointer<Void>)>(_createRenderPipelineCB);

    libwebgpu.wgpu_device_create_render_pipeline_async(
        object, d, cb, object.cast());

    desc.deleteNative(d);
    return pipeline;
    //return completer.future;
  }

  /// Create a [GpuCommandEncoder].
  GpuCommandEncoder createCommandEncoder() => GpuCommandEncoder(this);

  /// Create a [GpuQuerySet]
  GpuQuerySet createQuerySet(
          {required GpuQueryType type, required int count}) =>
      GpuQuerySet(this, type: type, count: count);

  /// Pushes a new GPU error scope onto the errorScopeStack.
  void pushErrorScope(GpuErrorFilter filter) {
    libwebgpu.wgpu_device_push_error_scope(object, filter.nativeIndex);
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
    final data = _callbackData[userData] as _GpuComputePipelineCreationData?;
    _callbackData.remove(userData);
    //final obj = GpuComputePipeline(data!.device!, pipeline);
    data!.object.setObject(pipeline);
    if (data.callback != null) {
      data.callback!(data.object);
    }
    //data.completer.complete(obj);
  }

  static void _createRenderPipelineCB(wgpu.WGpuDevice device,
      wgpu.WGpuPipelineBase pipeline, Pointer<Void> userData) {
    final data = _callbackData[userData] as _GpuRenderPipelineCreationData?;
    _callbackData.remove(userData);
    data!.object.setObject(pipeline);
    //final obj = GpuRenderPipeline(data!.device!, pipeline);
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
      final t = type >= 0 && type < GpuErrorType.values.length
          ? GpuErrorType.values[type]
          : GpuErrorType.unknown;
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
      final r = reason >= 0 && reason < GpuDeviceLostReason.values.length
          ? GpuDeviceLostReason.values[reason]
          : GpuDeviceLostReason.unknown;
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
      final t = type >= 0 && type < GpuErrorType.values.length
          ? GpuErrorType.values[type]
          : GpuErrorType.unknown;
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
  GpuDevice? device;
  _DeviceCallbackData(this.device);
}

class _ErrorScopeData extends _DeviceCallbackData {
  ErrorCallback callback;
  _ErrorScopeData(super.device, this.callback);
}

class _GpuComputePipelineCreationData extends _DeviceCallbackData {
  //Completer<GpuComputePipeline> completer;
  GpuComputePipeline object;
  GpuComputePipelineCallback? callback;
  _GpuComputePipelineCreationData(super.device, this.object, this.callback);
}

class _GpuRenderPipelineCreationData extends _DeviceCallbackData {
  //Completer<GpuRenderPipeline> completer;
  GpuRenderPipeline object;
  GpuRenderPipelineCallback? callback;
  _GpuRenderPipelineCreationData(super.device, this.object, this.callback);
}

final _callbackData = <Pointer<Void>, _DeviceCallbackData>{};
final _errorCallbackData = <Pointer<Void>, _DeviceCallbackData>{};
