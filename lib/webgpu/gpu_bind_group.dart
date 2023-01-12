import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_bind_group_entry.dart';
import 'gpu_bind_group_layout.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';

/// A BindGroup defines a set of resources to be bound together in a group and
/// how the resources are used in shader stages.
///
/// BindGroups are created from Device.createBindGroup().
class GPUBindGroup extends GPUObjectBase<wgpu.WGpuBindGroup> {
  final GPUDevice device;

  /// Create a BindGroup from the given [device].
  /// [layout] is the BindGroupLayout the entries of this bind group will
  /// conform to.
  /// [entries] is the list of entries describing the resources to expose to
  /// the shader for each binding described by the layout.
  GPUBindGroup(this.device,
      {required GPUBindGroupLayout layout, required List<Object> entries}) {
    device.addDependent(this);

    final sizeofEntry = sizeOf<wgpu.WGpuBindGroupEntry>();
    final numEntries = entries.length;
    final p = malloc<wgpu.WGpuBindGroupEntry>(sizeofEntry * numEntries);

    for (var i = 0; i < numEntries; ++i) {
      var e = entries[i];
      if (e is Map<String, Object>) {
        e = GPUBindGroupEntry.fromMap(e);
      }
      if (e is! GPUBindGroupEntry) {
        throw Exception('Invalid data for BindGroup entries.');
      }
      final binding = e.binding;
      final resource = e.resource;

      final offset = e.bufferOffset;
      final size = e.bufferSize;
      p.elementAt(i).ref
        ..binding = binding
        ..resource = resource.objectPtr.cast<wgpu.WGpuObjectDawn>()
        ..bufferBindOffset = offset
        ..bufferBindSize = size;
    }

    final o = libwebgpu.wgpu_device_create_bind_group(
        device.object, layout.object, p, numEntries);

    setObject(o);

    malloc.free(p);
  }
}