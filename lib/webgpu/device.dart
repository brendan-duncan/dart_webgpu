//import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'adapter.dart';
import 'address_mode.dart';
import 'bind_group.dart';
import 'bind_group_layout.dart';
import 'buffer.dart';
import 'buffer_usage.dart';
import 'command_encoder.dart';
import 'compare_function.dart';
import 'compute_pipeline.dart';
import 'compute_pipeline_descriptor.dart';
import 'device_lost_reason.dart';
import 'error_filter.dart';
import 'error_type.dart';
import 'features.dart';
import 'filter_mode.dart';
import 'limits.dart';
import 'pipeline_layout.dart';
import 'query_set.dart';
import 'query_type.dart';
import 'queue.dart';
import 'render_pipeline.dart';
import 'render_pipeline_descriptor.dart';
import 'sampler.dart';
import 'shader_module.dart';
import 'texture.dart';
import 'texture_dimension.dart';
import 'texture_format.dart';
import 'texture_usage.dart';
import 'wgpu_object.dart';

typedef ErrorCallback = void Function(
    Device device, ErrorType type, String message);

typedef DeviceLostCallback = void Function(
    Device device, DeviceLostReason reason, String message);

class Error {
  final String message;
  const Error(this.message);
}

typedef ComputePipelineCallback = void Function(ComputePipeline p);
typedef RenderPipelineCallback = void Function(RenderPipeline p);

/// A Device is the top-level interface through which WebGPU interfaces are
/// created.
///
/// A Device is asynchronously created from an Adapter through
/// Adapter.requestDevice.
class Device extends WGpuObjectBase<wgpu.WGpuDevice> {
  /// The [Adapter] that created this Device.
  Adapter adapter;

  /// The limits supported by the device (which are exactly the ones with which
  /// it was created).
  late final Limits limits;

  /// A set containing the Features values of the features supported by the
  /// device (i.e. the ones with which it was created).
  late final Features features;

  /// The default [Queue] of the Device.
  late final Queue queue;

  /// The lost callback will be called if the device is lost.
  final lost = <DeviceLostCallback>[];

  /// uncapturedError callbacks will be called for errors that weren't captured
  /// with pushErrorScope/popErrorScope.
  final uncapturedError = <ErrorCallback>[];

  Device(this.adapter, Pointer device) : super(device) {
    adapter.addDependent(this);
    features = Features(libwebgpu.wgpu_adapter_or_device_get_features(object));
    queue = Queue(this, libwebgpu.wgpu_device_get_queue(object));

    final l = calloc<wgpu.WGpuSupportedLimits>();
    libwebgpu.wgpu_adapter_or_device_get_limits(object, l);
    limits = Limits.fromWgpu(l);
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

  /// Create a [Buffer].
  Buffer createBuffer(
          {required int size,
          required BufferUsage usage,
          bool mappedAtCreation = false}) =>
      Buffer(this,
          size: size, usage: usage, mappedAtCreation: mappedAtCreation);

  /// Create a [Texture]
  Texture createTexture(
          {required int width,
          int height = 1,
          int depthOrArrayLayers = 1,
          required TextureFormat format,
          required TextureUsage usage,
          int mipLevelCount = 1,
          int sampleCount = 1,
          TextureDimension dimension = TextureDimension.texture2d,
          List<TextureFormat>? viewFormats}) =>
      Texture(this,
          width: width,
          height: height,
          depthOrArrayLayers: depthOrArrayLayers,
          mipLevelCount: mipLevelCount,
          sampleCount: sampleCount,
          dimension: dimension,
          format: format,
          usage: usage,
          viewFormats: viewFormats);

  /// Create a [Sampler]
  Sampler createSampler(
          {AddressMode addressModeU = AddressMode.clampToEdge,
          AddressMode addressModeV = AddressMode.clampToEdge,
          AddressMode addressModeW = AddressMode.clampToEdge,
          FilterMode magFilter = FilterMode.nearest,
          FilterMode minFilter = FilterMode.nearest,
          FilterMode mipmapFilter = FilterMode.nearest,
          num lodMinClamp = 0,
          num lodMaxClamp = 32,
          CompareFunction compare = CompareFunction.undefined,
          int maxAnisotropy = 1}) =>
      Sampler(this,
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

  /// Create a [BindGroupLayout]
  BindGroupLayout createBindGroupLayout({required List<Object> entries}) =>
      BindGroupLayout(this, entries: entries);

  /// Create a [PipelineLayout]
  PipelineLayout createPipelineLayout(List<BindGroupLayout> layouts) =>
      PipelineLayout(this, layouts);

  /// Create a [BindGroup]
  BindGroup createBindGroup(
          {required BindGroupLayout layout, required List<Object> entries}) =>
      BindGroup(this, layout: layout, entries: entries);

  /// Create a [ShaderModule].
  ShaderModule createShaderModule({required String code}) =>
      ShaderModule(this, code: code);

  /// Create a [ComputePipeline] synchronously
  ComputePipeline createComputePipeline({required Object descriptor}) {
    if (descriptor is Map<String, Object>) {
      descriptor = ComputePipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! ComputePipelineDescriptor) {
      throw Exception('Invalid descriptor for createComputePipeline');
    }

    final desc = descriptor as ComputePipelineDescriptor;

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

    return ComputePipeline(this, o);
  }

  /// Create a [RenderPipeline] synchronously.
  RenderPipeline createRenderPipeline({required Object descriptor}) {
    if (descriptor is Map<String, Object>) {
      descriptor = RenderPipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! RenderPipelineDescriptor) {
      throw Exception('Invalid descriptor for createRenderPipeline');
    }

    final desc = descriptor as RenderPipelineDescriptor;

    final d = desc.toNative();
    final o = libwebgpu.wgpu_device_create_render_pipeline(object, d);
    final pipeline = RenderPipeline(this, o);
    desc.deleteNative(d);
    return pipeline;
  }

  /// Create a [ComputePipeline] asynchronously
  /// Dart Future and await does not work yet with how WebGPU async works,
  /// so use the callback, or check the returned ComputePipeline.isValid
  /// property to check when the ComputePipeline is ready to be used.
  //Future<ComputePipeline> createComputePipelineAsync(
  ComputePipeline createComputePipelineAsync(
      {required Object descriptor,
      ComputePipelineCallback? callback}) /*async*/ {
    if (descriptor is Map<String, Object>) {
      descriptor = ComputePipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! ComputePipelineDescriptor) {
      throw Exception('Invalid descriptor for createComputePipeline');
    }

    final desc = descriptor as ComputePipelineDescriptor;

    //final completer = Completer<ComputePipeline>();

    final cb = Pointer.fromFunction<
        Void Function(wgpu.WGpuDevice, wgpu.WGpuPipelineBase,
            Pointer<Void>)>(_createComputePipelineCB);

    final pipeline = ComputePipeline(this);

    _callbackData[object.cast<Void>()] =
        _ComputePipelineCreationData(this, pipeline, callback);

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

  /// Create a [RenderPipeline] asynchronously.
  /// Dart Future and await does not work yet with how WebGPU async works,
  /// so use the callback, or check the returned RenderPipeline.isValid
  /// property to check when the RenderPipeline is ready to be used.
  //Future<RenderPipeline> createRenderPipelineAsync(
  RenderPipeline createRenderPipelineAsync(
      {required Object descriptor,
      RenderPipelineCallback? callback}) /*async*/ {
    if (descriptor is Map<String, Object>) {
      descriptor = RenderPipelineDescriptor.fromMap(descriptor);
    } else if (descriptor is! RenderPipelineDescriptor) {
      throw Exception('Invalid descriptor for createRenderPipelineAsync');
    }

    final desc = descriptor as RenderPipelineDescriptor;

    //final completer = Completer<RenderPipeline>();
    final pipeline = RenderPipeline(this);
    final d = desc.toNative();

    _callbackData[object.cast<Void>()] =
        _RenderPipelineCreationData(this, pipeline, callback);

    final cb = Pointer.fromFunction<
        Void Function(wgpu.WGpuDevice, wgpu.WGpuPipelineBase,
            Pointer<Void>)>(_createRenderPipelineCB);

    libwebgpu.wgpu_device_create_render_pipeline_async(
        object, d, cb, object.cast());

    desc.deleteNative(d);
    return pipeline;
    //return completer.future;
  }

  /// Create a [CommandEncoder].
  CommandEncoder createCommandEncoder() => CommandEncoder(this);

  /// Create a [QuerySet]
  QuerySet createQuerySet({required QueryType type, required int count}) =>
      QuerySet(this, type: type, count: count);

  /// Pushes a new GPU error scope onto the errorScopeStack.
  void pushErrorScope(ErrorFilter filter) {
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
    final data = _callbackData[userData] as _ComputePipelineCreationData?;
    _callbackData.remove(userData);
    //final obj = ComputePipeline(data!.device!, pipeline);
    data!.object.setObject(pipeline);
    if (data.callback != null) {
      data.callback!(data.object);
    }
    //data.completer.complete(obj);
  }

  static void _createRenderPipelineCB(wgpu.WGpuDevice device,
      wgpu.WGpuPipelineBase pipeline, Pointer<Void> userData) {
    final data = _callbackData[userData] as _RenderPipelineCreationData?;
    _callbackData.remove(userData);
    data!.object.setObject(pipeline);
    //final obj = RenderPipeline(data!.device!, pipeline);
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
      final t = type >= 0 && type < ErrorType.values.length
          ? ErrorType.values[type]
          : ErrorType.unknown;
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
      final r = reason >= 0 && reason < DeviceLostReason.values.length
          ? DeviceLostReason.values[reason]
          : DeviceLostReason.unknown;
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
      final t = type >= 0 && type < ErrorType.values.length
          ? ErrorType.values[type]
          : ErrorType.unknown;
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
  Device? device;
  _DeviceCallbackData(this.device);
}

class _ErrorScopeData extends _DeviceCallbackData {
  ErrorCallback callback;
  _ErrorScopeData(super.device, this.callback);
}

class _ComputePipelineCreationData extends _DeviceCallbackData {
  //Completer<ComputePipeline> completer;
  ComputePipeline object;
  ComputePipelineCallback? callback;
  _ComputePipelineCreationData(super.device, this.object, this.callback);
}

class _RenderPipelineCreationData extends _DeviceCallbackData {
  //Completer<RenderPipeline> completer;
  RenderPipeline object;
  RenderPipelineCallback? callback;
  _RenderPipelineCreationData(super.device, this.object, this.callback);
}

final _callbackData = <Pointer<Void>, _DeviceCallbackData>{};
final _errorCallbackData = <Pointer<Void>, _DeviceCallbackData>{};
