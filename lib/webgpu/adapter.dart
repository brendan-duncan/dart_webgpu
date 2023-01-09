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

/// An Adapter is the primary starting point of WebGPU. To use WebGPU, you
/// must request an Adapter with `final adapter = await Adapter.request();`
/// and then request a [Device] from the Adapter with
/// `final device = await adapter.requestDevice()`. The Device is then the
/// central point for creating WebGPU objects.
///
/// An Adapter identifies an implementation of WebGPU on the system: both an
/// instance of compute/rendering functionality on the platform, and an
/// instance of a platforms implementation of WebGPU on top of that
/// functionality.
///
/// Adapters do not uniquely represent underlying implementations: calling
/// requestAdapter() multiple times returns a different adapter object each
/// time.
///
/// An adapter object may become invalid at any time. This happens inside
/// "lose the device" and "mark adapters stale". An invalid adapter is unable
/// to vend new devices.
///
/// Note: This mechanism ensures that various adapter-creation scenarios look
/// similar to applications, so they can easily be robust to more scenarios
/// with less testing: first initialization, reinitialization due to an
/// unplugged adapter, reinitialization due to a test GPUDevice.destroy() call,
/// etc. It also ensures applications use the latest system state to make
/// decisions about which adapter to use.
///
/// An adapter may be considered a fallback adapter if it has significant
/// performance caveats in exchange for some combination of wider compatibility,
/// more predictable behavior, or improved privacy. It is not required that a
/// fallback adapter is available on every system.
class Adapter extends WGpuObjectBase<wgpu.WGpuAdapter> {
  /// A feature is a set of optional WebGPU functionality that is not supported
  /// on all implementations, typically due to hardware or system software
  /// constraints. The Adapter features lets you know what features are
  /// available on the system, from which you can include in the list of
  /// features you need when requesting a [Device].
  late final  Features features;

  /// Limits tell you the maximum value for various resources in the Adapter.
  late final Limits limits;

  /// Requests an adapter from the platform. The user agent chooses whether to
  /// return an Adapter, and, if so, chooses according to the provided options.
  ///
  /// [powerPreference] is a suggested request to specify if you would prefer a
  /// highPerformance external GPU, or a lowPower integrated GPU, on systems
  /// that have more than one GPU.
  ///
  /// [forceFallbackAdapter] can request the fallback adapter be returned,
  /// if available on the system. An adapter may be considered a fallback
  /// adapter if it has significant performance caveats in exchange for some
  /// combination of wider compatibility, more predictable behavior, or improved
  /// privacy.
  static Future<Adapter> request(
      {PowerPreference powerPreference = PowerPreference.highPerformance,
      bool forceFallbackAdapter = false}) {
    final o = calloc<wgpu.WGpuRequestAdapterOptions>();
    o.ref.powerPreference = powerPreference.nativeIndex;
    o.ref.forceFallbackAdapter = forceFallbackAdapter ? 1 : 0;

    final completer = Completer<Adapter>();
    _callbackData[o.cast<Void>()] = _AdapterCallbackData(null, completer);

    final cbp =
        Pointer.fromFunction<Void Function(wgpu.WGpuAdapter, Pointer<Void>)>(
            _requestAdapterCB);

    libwebgpu.navigator_gpu_request_adapter_async(o, cbp, o.cast<Void>());

    return completer.future;
  }

  /// An Adapter must be created with Adapter.request.
  Adapter._(Pointer o) : super(o) {
    features = Features(libwebgpu.wgpu_adapter_or_device_get_features(object))
        .remove(Features.shaderF16);
    final l = calloc<wgpu.WGpuSupportedLimits>();
    libwebgpu.wgpu_adapter_or_device_get_limits(object, l);
    limits = Limits.fromWgpu(l);
    calloc.free(l);
  }

  /// Asynchronously request a [Device] from this Adapter.
  /// [requiredFeatures] specifies the features that are required by the device
  /// request. The request will fail if the adapter cannot provide these
  /// features.
  /// [requiredLimits] specifies the limits that are required by the device
  /// request. The request will fail if the adapter cannot provide these limits.
  /// A value of 0 for al limit member implies the Adapter's maximum for that
  /// limit value should be used. Exactly the specified limits, and no better or
  /// worse, will be allowed in validation of API calls on the resulting device.
  /// [defaultQueue] is an optional descriptor to use for the default Queue
  /// object created by the Device.
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

  /// Returns true if the Adapter supports the given set of features.
  bool supportsFeature(Features features) => features.supports(features);

  /// Is true if this adapter is a fallback adapter.
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

class _AdapterCallbackData {
  Adapter? adapter;
  Completer<WGpuObjectBase<wgpu.WGpuObjectBase>> completer;

  _AdapterCallbackData(this.adapter, this.completer);
}

final _callbackData = <Pointer<Void>, _AdapterCallbackData>{};
