import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import '../webgpu/gpu_adapter.dart';
import '../webgpu/gpu_device.dart';
import '../webgpu/gpu_texture_format.dart';
import '../webgpu/gpu_texture_usage.dart';
import 'gpu_window_context.dart';

class GPUWindow {
  late wgpu.WGpuWindow object;
  late int _width;
  late int _height;
  int _mouseX = 0;
  int _mouseY = 0;
  int _deltaX = 0;
  int _deltaY = 0;
  bool _firstEvent = true;
  int _mouseButton = 0;

  GPUWindow(
      {required int width, required int height, String title = "Dart WebGPU"}) {
    _width = width;
    _height = height;
    final cs = title.toNativeUtf8();
    object = libwebgpu.wgpu_create_window(width, height, cs.cast<Char>());
  }

  int get width => _width;

  int get height => _height;

  bool get shouldQuit => libwebgpu.wgpu_window_should_quit(object) == 1;

  int get mouseX => _mouseX;

  int get mouseY => _mouseY;

  int get deltaX => _deltaX;

  int get deltaY => _deltaY;

  int get mouseButton => _mouseButton;

  void pollEvents() {
    libwebgpu.wgpu_window_poll_events(object);
    final mx = _mouseX;
    final my = _mouseY;
    _mouseX = libwebgpu.wgpu_window_mouse_position_x();
    _mouseY = libwebgpu.wgpu_window_mouse_position_y();
    if (!_firstEvent) {
      _deltaX = _mouseX - mx;
      _deltaY = _mouseY - my;
    }
    _firstEvent = false;
    _mouseButton = libwebgpu.wgpu_window_mouse_button();
  }

  bool isKeyPressed(int key) => libwebgpu.wgpu_window_get_key(object, key) != 0;

  GPUWindowContext createContext(GPUAdapter adapter, GPUDevice device,
          {GPUTextureFormat? format,
          GPUTextureUsage usage = GPUTextureUsage.renderAttachment,
          List<GPUTextureFormat>? viewFormats}) =>
      GPUWindowContext(this,
          adapter: adapter,
          device: device,
          format: format,
          usage: usage,
          viewFormats: viewFormats);
}
