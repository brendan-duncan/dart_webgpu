import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import '../webgpu/device.dart';
import '../webgpu/texture_format.dart';
import '../webgpu/texture_usage.dart';
import '../webgpu/texture_view.dart';
import '../webgpu/wgpu_object.dart';
import 'window.dart';

class WindowContext extends WGpuObjectBase<wgpu.WGpuCanvasContext> {
  final Window window;
  final Device device;
  late final TextureFormat preferredFormat;

  WindowContext(this.window,
      {required this.device,
      TextureFormat? format,
      TextureUsage usage = TextureUsage.renderAttachment,
      List<TextureFormat>? viewFormats}) {
    final f = libwebgpu.navigator_gpu_get_preferred_canvas_format();
    preferredFormat = TextureFormat.values[f - 1];
    configure(format: format, usage: usage, viewFormats: viewFormats);
  }

  void configure(
      {TextureFormat? format,
      TextureUsage usage = TextureUsage.renderAttachment,
      List<TextureFormat>? viewFormats}) {
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
      c.ref.viewFormats.elementAt(i).value = viewFormats![i].nativeIndex;
    }

    libwebgpu.wgpu_canvas_context_configure(
        object, c, window.width, window.height);

    if (numViewFormats > 0) {
      calloc.free(c.ref.viewFormats);
    }
    calloc.free(c);
  }

  TextureView getCurrentTextureView() {
    final view = libwebgpu.wgpu_canvas_context_get_current_texture_view(object);
    return TextureView.native(view);
  }

  void present() {
    libwebgpu.wgpu_canvas_context_present(object);
    /*libwebgpu
      ..wgpu_canvas_context_present(object)
      ..wgpu_window_poll_events();*/
  }
}
