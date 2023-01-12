import 'dart:ffi';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';

/// Base class for WebGPU objects. The methods of this class are considered
/// @internal.
abstract class GpuObject implements Finalizable {
  /// The pointer to the native WebGPU object.
  Pointer objectPtr = nullptr;
  GpuObject? _parent;

  /// The list of WebGPU objects this object created. When this object is
  /// destroyed, it will also destroy any objects that it has created.
  final dependents = <GpuObject>[];

  GpuObject([Pointer? object, GpuObject? parent]) {
    if (object != null) {
      setObject(object);
    }
    if (parent != null) {
      parent.addDependent(this);
    }
  }

  /// The WebGPU object that created this object.
  GpuObject? get parent => _parent;

  /// True if this object is alive, and false if it has been destroyed.
  bool get isValid => objectPtr != nullptr;

  /// Add a dependent to this object.
  void addDependent(GpuObject o) {
    o._parent = this;
    dependents.add(o);
  }

  /// Remove a dependent from this object, because it's been destroyed.
  void removeDependent(GpuObject o) {
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
    final dep = List<GpuObject>.from(dependents, growable: false);
    for (final d in dep) {
      d.destroy();
    }
    dependents.clear();
  }
}

class GpuObjectBase<T> extends GpuObject {
  GpuObjectBase([Pointer? object, GpuObject? parent]) : super(object, parent);

  T get object => objectPtr as T;
}
