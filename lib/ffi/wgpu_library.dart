import 'dart:ffi';
import 'dart:io';

import 'ffi_webgpu.dart';

class WGpuLibrary {
  late DynamicLibrary library;
  late NativeLibrary wgpu;

  static late final WGpuLibrary _global = WGpuLibrary._();
  static WGpuLibrary get() {
    return _global;
  }

  WGpuLibrary._() {
    library = _dlopenWebGpu();
    wgpu = NativeLibrary(library);
  }

  void attachFinalizer(Finalizable object, Pointer<Void> token) {
    finalizer.attach(object, token, detach: object);
  }

  void detachFinalizer(Finalizable object) {
    finalizer.detach(object);
  }

  void destroyObject(WGpuObjectBase object) {
    wgpu.wgpu_object_destroy(object);
  }

  late final wgpuObjectDestroy =
      library.lookup<NativeFunction<Void Function(WGpuObjectBase)>>(
          'wgpu_object_destroy');

  late final finalizer = NativeFinalizer(wgpuObjectDestroy.cast());

  String _getLibraryPath() {
    final path = '${Directory.current.path}/libwebgpu/libs/win-Release/';
    if (Platform.isMacOS) {
      return '$path/libwebgpu.dylib';
    }
    if (Platform.isWindows) {
      return '$path/webgpu.dll';
    }
    return '$path/libwebgpu.so';
  }

  DynamicLibrary _dlopenWebGpu() {
    final path = _getLibraryPath();
    return DynamicLibrary.open(path);
  }
}

WGpuLibrary get webgpu => WGpuLibrary.get();
NativeLibrary get library => WGpuLibrary.get().wgpu;
