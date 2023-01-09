import 'dart:ffi';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';

/// Base class for WebGPU objects. The methods of this class are considered
/// @internal.
abstract class WGpuObject implements Finalizable {
  /// The pointer to the native WebGPU object.
  Pointer objectPtr = nullptr;
  WGpuObject? _parent;
  /// The list of WebGPU objects this object created. When this object is
  /// destroyed, it will also destroy any objects that it has created.
  final dependents = <WGpuObject>[];

  WGpuObject([Pointer? object, WGpuObject? parent]) {
    if (object != null) {
      setObject(object);
    }
    if (parent != null) {
      parent.addDependent(this);
    }
  }

  /// The WebGPU object that created this object.
  WGpuObject? get parent => _parent;

  /// True if this object is alive, and false if it has been destroyed.
  bool get isValid => objectPtr != nullptr;

  /// Add a dependent to this object.
  void addDependent(WGpuObject o) {
    o._parent = this;
    dependents.add(o);
  }

  /// Remove a dependent from this object, because it's been destroyed.
  void removeDependent(WGpuObject o) {
    o._parent = null;
    dependents.remove(o);
  }

  /// Set the WebGPU object pointer owned by this object.
  void setObject(Pointer o) {
    if (objectPtr == nullptr) {
      objectPtr = o;
      webgpu.attachFinalizer(this, objectPtr.cast());
    }
  }

  /// Destroy the object and all of the objects this object has created.
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

  /// Destroy all of the objects this object has created.
  void destroyDependents() {
    // The dependents list will be modified from destroying the child
    final dep = List<WGpuObject>.from(dependents, growable: false);
    for (final d in dep) {
      d.destroy();
    }
    dependents.clear();
  }
}

class WGpuObjectBase<T> extends WGpuObject {
  WGpuObjectBase([Pointer? object, WGpuObject? parent]) : super(object, parent);

  T get object => objectPtr as T;
}
