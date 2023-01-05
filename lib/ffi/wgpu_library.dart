import 'dart:ffi';
import 'dart:io';

import 'ffi_webgpu.dart' as lib;

class WGpuLibrary {
  late DynamicLibrary library;
  late lib.libwebgpu wgpu;

  static final WGpuLibrary _global = WGpuLibrary._();
  static WGpuLibrary get() => _global;

  WGpuLibrary._() {
    library = _dlopenWebGpu();
    wgpu = lib.libwebgpu(library);
  }

  void attachFinalizer(Finalizable object, Pointer<Void> token) {
    finalizer.attach(object, token, detach: object);
  }

  void detachFinalizer(Finalizable object) {
    finalizer.detach(object);
  }

  void destroyObject(lib.WGpuObjectBase object) {
    wgpu.wgpu_object_destroy(object);
  }

  late final wgpuObjectDestroy =
      library.lookup<NativeFunction<Void Function(lib.WGpuObjectBase)>>(
          'wgpu_object_destroy');

  late final finalizer = NativeFinalizer(wgpuObjectDestroy.cast());

  String _getLibraryPath() {
    final path = '${Directory.current.path}/libwebgpu/lib';
    if (Platform.isMacOS) {
      return '$path/mac-arm64-Release/libwebgpu.dylib';
    }
    if (Platform.isWindows) {
      return '$path/win-Release/webgpu.dll';
    }
    return '$path/linux-Release/libwebgpu.so';
  }

  DynamicLibrary _dlopenWebGpu() {
    final path = _getLibraryPath();
    return DynamicLibrary.open(path);
  }
}

WGpuLibrary get webgpu => WGpuLibrary.get();
lib.libwebgpu get libwebgpu => WGpuLibrary.get().wgpu;
