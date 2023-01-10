import 'dart:ffi';
import 'dart:io';

import 'ffi_webgpu.dart' as lib;

class WGpuLibrary {
  static bool _debug = false;

  late DynamicLibrary library;
  late lib.libwebgpu wgpu;

  static final WGpuLibrary _global = WGpuLibrary._();
  static WGpuLibrary get() => _global;

  /// Call WGpuLibrary.initialize(debug: true) prior to using any WebGPU
  /// commands to have it load the Debug library instead of the Release library.
  static initialize({bool debug = false}) {
    _debug = debug;
  }

  WGpuLibrary._() {
    library = _dlopen();
    wgpu = lib.libwebgpu(library);
  }

  void attachFinalizer(Finalizable object, Pointer<Void> token) {
    _finalizer.attach(object, token, detach: object);
  }

  void detachFinalizer(Finalizable object) {
    _finalizer.detach(object);
  }

  void destroyObject(lib.WGpuObjectBase object) {
    wgpu.wgpu_object_destroy(object);
  }

  late final _wgpuObjectDestroy =
      library.lookup<NativeFunction<Void Function(lib.WGpuObjectBase)>>(
          'wgpu_object_finalize_dart');

  late final _finalizer = NativeFinalizer(_wgpuObjectDestroy.cast());

  String _getLibraryPath() {
    final path = '${Directory.current.path}/libwebgpu/lib';
    final config = _debug ? 'Debug' : 'Release';
    if (Platform.isMacOS) {
      return '$path/mac-arm64-$config/libwebgpu.dylib';
    }
    if (Platform.isWindows) {
      return '$path/win-$config/webgpu.dll';
    }
    return '$path/linux-$config/libwebgpu.so';
  }

  DynamicLibrary _dlopen() {
    final path = _getLibraryPath();
    //print('#### LOADING $path');
    return DynamicLibrary.open(path);
  }
}

WGpuLibrary get webgpu => WGpuLibrary.get();
lib.libwebgpu get libwebgpu => WGpuLibrary.get().wgpu;
