import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import '../webgpu/device.dart';
import '../webgpu/texture_format.dart';
import '../webgpu/texture_usage.dart';
import '../webgpu/texture_view.dart';

class Window {
  late wgpu.WGpuWindow window;
  late wgpu.WGpuCanvasContext context;

  Window(
      {required int width,
      required int height,
      String title = "Dart WebGPU",
      required Device device}) {
    final cs = title.toNativeUtf8();
    window = libwebgpu.wgpu_create_window(width, height, cs.cast<Char>());
    context = libwebgpu.wgpu_window_get_webgpu_context(window);

    final c = calloc<wgpu.WGpuCanvasConfiguration>();
    c.ref.device = device.object;
    c.ref.format = TextureFormat.bgra8Unorm.nativeIndex;
    c.ref.usage = TextureUsage.renderAttachment.value;
    c.ref.colorSpace = 1; // HTML_PREDEFINED_COLOR_SPACE_SRGB
    c.ref.alphaMode = 1; // WGPU_CANVAS_ALPHA_MODE_OPAQUE
    libwebgpu.wgpu_canvas_context_configure(context, c, width, height);
    calloc.free(c);
  }

  bool get shouldQuit => libwebgpu.wgpu_window_should_quit(window) == 1;

  TextureView getCurrentTextureView() {
    final view =
        libwebgpu.wgpu_canvas_context_get_current_texture_view(context);
    return TextureView.native(view);
  }

  void present() {
    libwebgpu
      ..wgpu_canvas_context_present(context)
      ..wgpu_window_poll_events();
  }
}
