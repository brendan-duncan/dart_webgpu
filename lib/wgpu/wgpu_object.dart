import 'dart:ffi';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';

class WGpuObject<T> implements Finalizable {
  Pointer _object = nullptr;
  WGpuObject? _parent;
  List<WGpuObject> _dependents = [];

  WGpuObject([Pointer? o]) {
    if (o != null) {
      setObject(o);
    }
  }

  void addDependent(WGpuObject o) {
    o._parent = this;
    _dependents.add(o);
  }

  void removeDependent(WGpuObject o) {
    o._parent = null;
    _dependents.remove(o);
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
    destroyDependents();
    webgpu.detachFinalizer(this);
    webgpu.destroyObject(_object as wgpu.WGpuObjectBase);
    _object = nullptr;
    if (_parent != null) {
      _parent!.removeDependent(this);
    }
  }

  void destroyDependents() {
    // The dependents list will be modified from destroying the child
    final dependents = List.from(_dependents, growable: false);
    for (final d in dependents) {
      d.destroy();
    }
    _dependents.clear();
  }
}
