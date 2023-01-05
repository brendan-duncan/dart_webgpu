import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
//import 'adapter_info.dart';
import 'adapter_options.dart';
import 'device.dart';
import 'device_descriptor.dart';
import 'limits.dart';
import 'features.dart';
import 'wgpu_object.dart';

class _AdapterCallbackData {
  Adapter? adapter;
  Completer completer;

  _AdapterCallbackData(this.adapter, this.completer);
}

final _callbackData = <Pointer<Void>, _AdapterCallbackData>{};

class Adapter extends WGpuObject<wgpu.WGpuAdapter> {
  late Features features;
  late Limits limits;

  static Future<Adapter> request(AdapterOptions? options) {
    final o = calloc<wgpu.WGpuRequestAdapterOptions>();
    o.ref.powerPreference = options?.powerPreference.index ?? 2;
    o.ref.forceFallbackAdapter =
        (options?.forceFallbackAdapter ?? false) ? 1 : 0;

    final completer = Completer<Adapter>();
    _callbackData[o.cast<Void>()] = _AdapterCallbackData(null, completer);

    final cbp =
        Pointer.fromFunction<Void Function(wgpu.WGpuAdapter, Pointer<Void>)>(
            _requestAdapterCB);

    library.navigator_gpu_request_adapter_async(o, cbp, o.cast<Void>());

    return completer.future;
  }

  Adapter._(Pointer o)
    : super(o) {
    features = Features(library.wgpu_adapter_or_device_get_features(object))
        .remove(Features.shaderF16);
    _getLimits();
  }

  void _getLimits() {
    final l = calloc<wgpu.WGpuSupportedLimits>();
    library.wgpu_adapter_or_device_get_limits(object, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);
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

    _callbackData[o.cast<Void>()] = _AdapterCallbackData(this, completer);

    final cbp =
        Pointer.fromFunction<Void Function(wgpu.WGpuDevice, Pointer<Void>)>(
            _requestDeviceCB);

    library.wgpu_adapter_request_device_async(object, o, cbp, o.cast<Void>());

    return completer.future;
  }

  bool supportsFeature(Features features) => features.supports(features);

  bool get isFallbackAdapter =>
      library.wgpu_adapter_is_fallback_adapter(object) == 1 ? true : false;

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
    final data = _callbackData[userData];
    _callbackData.remove(userData);
    calloc.free(userData);
    if (data?.completer != null) {
      data!.completer.complete(Device(data.adapter!, device));
    }
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
