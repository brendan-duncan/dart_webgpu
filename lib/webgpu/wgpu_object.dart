import 'dart:ffi';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';

class WGpuObjectBase implements Finalizable {
  Pointer objectPtr = nullptr;
  WGpuObjectBase? _parent;
  final _dependents = <WGpuObjectBase>[];

  WGpuObjectBase([Pointer? object, WGpuObjectBase? parent]) {
    if (object != null) {
      setObject(object);
    }
    if (parent != null) {
      parent.addDependent(this);
    }
  }

  void addDependent(WGpuObjectBase o) {
    o._parent = this;
    _dependents.add(o);
  }

  void removeDependent(WGpuObjectBase o) {
    o._parent = null;
    _dependents.remove(o);
  }

  void setObject(Pointer o) {
    if (objectPtr == nullptr) {
      objectPtr = o;
      webgpu.attachFinalizer(this, objectPtr.cast());
    }
  }

  bool get isValid => objectPtr != nullptr;

  void destroy() {
    destroyDependents();
    webgpu
      ..detachFinalizer(this)
      ..destroyObject(objectPtr as wgpu.WGpuObjectBase);
    objectPtr = nullptr;
    if (_parent != null) {
      _parent!.removeDependent(this);
    }
  }

  void destroyDependents() {
    // The dependents list will be modified from destroying the child
    final dependents = List<WGpuObjectBase>.from(_dependents, growable: false);
    for (final d in dependents) {
      d.destroy();
    }
    _dependents.clear();
  }
}

class WGpuObject<T> extends WGpuObjectBase {
  WGpuObject([Pointer? object, WGpuObjectBase? parent]) : super(object, parent);

  T get object => objectPtr as T;
}
