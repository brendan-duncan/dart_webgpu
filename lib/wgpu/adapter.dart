import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'device.dart';
import 'features.dart';
import 'limits.dart';
import 'power_preference.dart';
import 'wgpu_object.dart';

class _AdapterCallbackData {
  Adapter? adapter;
  Completer<WGpuObject<wgpu.WGpuObjectBase>> completer;

  _AdapterCallbackData(this.adapter, this.completer);
}

final _callbackData = <Pointer<Void>, _AdapterCallbackData>{};

class Adapter extends WGpuObject<wgpu.WGpuAdapter> {
  late Features features;
  late Limits limits;

  static Future<Adapter> request(
      {PowerPreference powerPreference = PowerPreference.highPerformance,
      bool forceFallbackAdapter = false}) {
    final o = calloc<wgpu.WGpuRequestAdapterOptions>();
    o.ref.powerPreference = powerPreference.index;
    o.ref.forceFallbackAdapter = forceFallbackAdapter ? 1 : 0;

    final completer = Completer<Adapter>();
    _callbackData[o.cast<Void>()] = _AdapterCallbackData(null, completer);

    final cbp =
        Pointer.fromFunction<Void Function(wgpu.WGpuAdapter, Pointer<Void>)>(
            _requestAdapterCB);

    libwebgpu.navigator_gpu_request_adapter_async(o, cbp, o.cast<Void>());

    return completer.future;
  }

  Adapter._(Pointer o) : super(o) {
    features = Features(libwebgpu.wgpu_adapter_or_device_get_features(object))
        .remove(Features.shaderF16);
    _getLimits();
  }

  void _getLimits() {
    final l = calloc<wgpu.WGpuSupportedLimits>();
    libwebgpu.wgpu_adapter_or_device_get_limits(object, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);
  }

  Future<Device> requestDevice(
      {Features? requiredFeatures,
      Limits? requiredLimits,
      String? defaultQueue}) async {
    final completer = Completer<Device>();

    final o = calloc<wgpu.WGpuDeviceDescriptor>();
    o.ref.requiredFeatures = requiredFeatures?.value ?? 0;

    requiredLimits?.copyTo(o.ref.requiredLimits);
    if (defaultQueue != null) {
      final q = defaultQueue.toNativeUtf8();
      o.ref.defaultQueue.label = q.cast<Char>();
      calloc.free(q);
    }

    _callbackData[o.cast<Void>()] = _AdapterCallbackData(this, completer);

    final fn =
        Pointer.fromFunction<Void Function(wgpu.WGpuDevice, Pointer<Void>)>(
            _requestDeviceCB);

    libwebgpu.wgpu_adapter_request_device_async(object, o, fn, o.cast<Void>());

    return completer.future;
  }

  bool supportsFeature(Features features) => features.supports(features);

  bool get isFallbackAdapter =>
      libwebgpu.wgpu_adapter_is_fallback_adapter(object) == 1;

  static void _requestDeviceCB(wgpu.WGpuDevice device, Pointer<Void> userData) {
    final data = _callbackData[userData];
    _callbackData.remove(userData);
    calloc.free(userData);
    data?.completer.complete(Device(data.adapter!, device));
  }
}

void _requestAdapterCB(wgpu.WGpuAdapter adapter, Pointer<Void> userData) {
  final data = _callbackData[userData];
  _callbackData.remove(userData);
  calloc.free(userData);
  if (data?.completer != null) {
    data!.completer.complete(Adapter._(adapter));
  }
}
