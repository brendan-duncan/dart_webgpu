import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'adapter_info.dart';
import 'adapter_options.dart';
import 'device.dart';
import 'device_descriptor.dart';
import 'limits.dart';
import 'features.dart';

final _callbackData = <Pointer<Void>, Completer>{};

class Adapter implements Finalizable {
  wgpu.WGpuAdapter adapter;
  late Features features;
  late Limits limits;

  static Future<Adapter> request(AdapterOptions? options) {
    final o = calloc<wgpu.WGpuRequestAdapterOptions>();
    o.ref.powerPreference = options?.powerPreference.index ?? 2;
    o.ref.forceFallbackAdapter =
        (options?.forceFallbackAdapter ?? false) ? 1 : 0;

    final completer = Completer<Adapter>();
    _callbackData[o.cast<Void>()] = completer;

    final cbp =
        Pointer.fromFunction<Void Function(wgpu.WGpuAdapter, Pointer<Void>)>(
            _requestAdapterCB);

    library.navigator_gpu_request_adapter_async(o, cbp, o.cast<Void>());

    return completer.future;
  }

  Adapter._(this.adapter) {
    webgpu.attachFinalizer(this, adapter.cast());
    features = Features(library.wgpu_adapter_or_device_get_features(adapter))
        .remove(Features.shaderF16);
    _getLimits();
  }

  void _getLimits() {
    final l = calloc<wgpu.WGpuSupportedLimits>();
    library.wgpu_adapter_or_device_get_limits(adapter, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);
  }

  bool get isValid => adapter != nullptr;

  void destroy() {
    webgpu.detachFinalizer(this);
    webgpu.destroyObject(adapter);
    adapter = nullptr;
  }

  Future<Device> requestDevice([DeviceDescriptor? descriptor]) async {
    final completer = Completer<Device>();

    final o = calloc<wgpu.WGpuDeviceDescriptor>();
    o.ref.requiredFeatures = descriptor?.requiredFeatures?.value ?? 0;

    descriptor?.requiredLimits?.copyTo(o.ref.requiredLimits);
    if (descriptor?.defaultQueue?.label != null) {
      final q = descriptor!.defaultQueue!.label.toNativeUtf8();
      o.ref.defaultQueue.label = q.cast<Char>();
      calloc.free(q);
    }

    _callbackData[o.cast<Void>()] = completer;

    final cbp =
        Pointer.fromFunction<Void Function(wgpu.WGpuDevice, Pointer<Void>)>(
            _requestDeviceCB);

    library.wgpu_adapter_request_device_async(adapter, o, cbp, o.cast<Void>());

    return completer.future;
  }

  bool supportsFeature(Features features) => features.supports(features);

  bool get isFallbackAdapter =>
      library.wgpu_adapter_is_fallback_adapter(adapter) == 1 ? true : false;

  /*Future<AdapterInfo> requestAdapterInfo() async {
    final completer = Completer<AdapterInfo>();

    final o = calloc<wgpu.WGpuDeviceDescriptor>();
    _callbackData[o.cast<Void>()] = completer;

    final cbp = Pointer.fromFunction<
        Void Function(wgpu.WGpuAdapter, Pointer<wgpu.WGpuAdapterInfo>,
            Pointer<Void>)>(_requestInfoCB);

    library.wgpu_adapter_request_adapter_info_async(
        adapter, unmaskHints, cbp, o.cast<Void>());

    return completer.future;
  }

  static void _requestInfoCB(wgpu.WGpuAdapter adapter,
      Pointer<wgpu.WGpuAdapterInfo> info, Pointer<Void> userData) {
    final completer = _callbackData[userData];
    _callbackData.remove(userData);
    calloc.free(userData);
    if (completer != null) {
      final vendor = '';
      final architecture = '';
      final device = '';
      final description = '';
      completer
          .complete(AdapterInfo(vendor, architecture, device, description));
    }
  }*/

  static void _requestDeviceCB(wgpu.WGpuDevice device, Pointer<Void> userData) {
    final completer = _callbackData[userData];
    _callbackData.remove(userData);
    calloc.free(userData);
    if (completer != null) {
      completer.complete(Device(device));
    }
  }
}

void _requestAdapterCB(wgpu.WGpuAdapter adapter, Pointer<Void> userData) {
  final completer = _callbackData[userData];
  _callbackData.remove(userData);
  calloc.free(userData);
  if (completer != null) {
    completer.complete(Adapter._(adapter));
  }
}
