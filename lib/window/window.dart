import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import '../webgpu/gpu_device.dart';
import '../webgpu/gpu_texture_format.dart';
import '../webgpu/gpu_texture_usage.dart';
import 'window_context.dart';

class Window {
  late wgpu.WGpuWindow object;
  late int _width;
  late int _height;

  Window(
      {required int width, required int height, String title = "Dart WebGPU"}) {
    _width = width;
    _height = height;
    final cs = title.toNativeUtf8();
    object = libwebgpu.wgpu_create_window(width, height, cs.cast<Char>());
  }

  int get width => _width;

  int get height => _height;

  bool get shouldQuit => libwebgpu.wgpu_window_should_quit(object) == 1;

  void pollEvents() => libwebgpu.wgpu_window_poll_events();

  WindowContext createContext(GpuDevice device,
          {GpuTextureFormat? format,
          GpuTextureUsage usage = GpuTextureUsage.renderAttachment,
          List<GpuTextureFormat>? viewFormats}) =>
      WindowContext(this,
          device: device,
          format: format,
          usage: usage,
          viewFormats: viewFormats);
}
