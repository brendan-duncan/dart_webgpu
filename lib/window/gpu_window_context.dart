import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import '../webgpu/gpu_adapter.dart';
import '../webgpu/gpu_device.dart';
import '../webgpu/gpu_object.dart';
import '../webgpu/gpu_texture_format.dart';
import '../webgpu/gpu_texture_usage.dart';
import '../webgpu/gpu_texture_view.dart';
import 'gpu_window.dart';

class GPUWindowContext extends GPUObjectBase<wgpu.WGpuCanvasContext> {
  final GPUWindow window;
  final GPUAdapter adapter;
  final GPUDevice device;
  late final GPUTextureFormat preferredFormat;

  GPUWindowContext(this.window,
      {required this.adapter,
      required this.device,
      GPUTextureFormat? format,
      GPUTextureUsage usage = GPUTextureUsage.renderAttachment,
      List<GPUTextureFormat>? viewFormats}) {
    final f = libwebgpu.navigator_gpu_get_preferred_canvas_format(
        adapter.object, object);
    preferredFormat = GPUTextureFormat.values[f - 1];
    configure(format: format, usage: usage, viewFormats: viewFormats);
  }

  void configure(
      {GPUTextureFormat? format,
      GPUTextureUsage usage = GPUTextureUsage.renderAttachment,
      List<GPUTextureFormat>? viewFormats}) {
    final o = libwebgpu.wgpu_window_get_webgpu_context(window.object);
    setObject(o);

    format ??= preferredFormat;

    final numViewFormats = viewFormats?.length ?? 0;

    final c = calloc<wgpu.WGpuCanvasConfiguration>();
    c.ref
      ..device = device.object
      ..format = format.nativeIndex
      ..usage = usage.value
      ..colorSpace = 1 // HTML_PREDEFINED_COLOR_SPACE_SRGB
      ..alphaMode = 1 // WGPU_CANVAS_ALPHA_MODE_OPAQUE
      ..numViewFormats = numViewFormats
      ..viewFormats = calloc<wgpu.WGPU_TEXTURE_FORMAT>(numViewFormats);
    for (var i = 0; i < numViewFormats; ++i) {
      (c.ref.viewFormats + i).value = viewFormats![i].nativeIndex;
    }

    libwebgpu.wgpu_canvas_context_configure(
        object, c, window.width, window.height);

    if (numViewFormats > 0) {
      calloc.free(c.ref.viewFormats);
    }
    calloc.free(c);
  }

  GPUTextureView getCurrentTextureView() {
    final view = libwebgpu.wgpu_canvas_context_get_current_texture_view(object);
    return GPUTextureView.native(view);
  }

  void present() {
    libwebgpu.wgpu_canvas_context_present(object);
  }
}
