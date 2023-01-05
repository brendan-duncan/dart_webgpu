import 'dart:ffi';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';

class WGpuObject<T> implements Finalizable {
  Pointer _object = nullptr;

  WGpuObject([Pointer? o]) {
    if (o != null) {
      setObject(o);
    }
  }

  void setObject(Pointer o) {
    if (_object == nullptr) {
      _object = o;
      webgpu.attachFinalizer(this, _object.cast());
    }
  }

  T get object => _object as T;

  bool get isValid => _object != nullptr;

  void destroy() {
    webgpu.detachFinalizer(this);
    webgpu.destroyObject(_object as wgpu.WGpuObjectBase);
    _object = nullptr;
  }
}
