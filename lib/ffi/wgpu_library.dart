import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'ffi_webgpu.dart' as lib;
import 'wgpu_config.dart';

class WGpuLibrary {
  DynamicLibrary? _library;
  lib.libwebgpu? _wgpu;

  static final WGpuLibrary _global = WGpuLibrary._();
  static WGpuLibrary get() => _global;

  WGpuLibrary._();

  Future<void> initialize({WGpuConfig config = WGpuConfig.release}) async {
    if (_library == null) {
      _library = await _dlopen(config: config);
      _wgpu = lib.libwebgpu(_library!);
    }
  }

  DynamicLibrary get library => _library!;

  lib.libwebgpu get wgpu => _wgpu!;

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

  Future<String> _getLibraryPath({required WGpuConfig config}) async {
    final packagePath = Directory.current.path;
    String libPath;
    if (Directory('$packagePath/libwebgpu/lib').existsSync()) {
      libPath = '$packagePath/libwebgpu/lib';
    } else {
      final packageUri = Uri.parse('package:webgpu/_native');
      final uri = await Isolate.resolvePackageUri(packageUri);
      if (uri == null) {
        throw Exception('Could not resolve webgpu package directory.');
      }
      final dir = Directory.fromUri(uri);
      if (!dir.existsSync()) {
        throw Exception('Could not resolve webgpu package directory.');
      }
      libPath = dir.path;
    }

    // This is the order that it will search for libraries. Packaged
    // distributions on pub would only have Release, so even asking for
    // debug would fall through to Release.
    final configs = config == WGpuConfig.release
        ? ['Release']
        : config == WGpuConfig.debug
            ? ['Debug', 'RelWithDebInfo', 'Release']
            : ['RelWithDebInfo', 'Release'];

    final platform = Platform.isWindows
        ? 'win-x64'
        : Platform.isMacOS
            ? 'mac-arm64'
            : 'linux-x64';

    for (final config in configs) {
      final path = '$libPath/$platform-$config';
      if (!Directory(path).existsSync()) {
        continue;
      }

      if (Platform.isWindows) {
        return '$path/webgpu.dll';
      }

      if (Platform.isMacOS) {
        return '$path/libwebgpu.dylib';
      }

      return '$path/libwebgpu.so';
    }

    throw Exception('Could not find native webgpu library');
  }

  Future<DynamicLibrary> _dlopen({required WGpuConfig config}) async {
    final path = await _getLibraryPath(config: config);
    print('#### LOADING $path');
    return DynamicLibrary.open(path);
  }
}

WGpuLibrary get webgpu => WGpuLibrary.get();
lib.libwebgpu get libwebgpu => WGpuLibrary.get().wgpu;
