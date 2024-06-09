import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_bind_group_entry.dart';
import 'gpu_bind_group_layout.dart';
import 'gpu_buffer_binding.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';

/// A GPUBindGroup defines a set of resources to be bound together in a group
/// and how the resources are used in shader stages.
///
/// GPUBindGroups are created from GPUDevice.createBindGroup().
class GPUBindGroup extends GPUObjectBase<wgpu.WGpuBindGroup> {
  /// Create a BindGroup from the given [device].
  /// [layout] is the BindGroupLayout the entries of this bind group will
  /// conform to.
  /// [entries] is the list of entries describing the resources to expose to
  /// the shader for each binding described by the layout.
  GPUBindGroup(GPUDevice device,
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
      var resource = e.resource;
      int offset;
      int size;
      if (resource is GPUBufferBinding) {
        offset = resource.offset;
        size = resource.size;
        resource = resource.buffer;
      } else {
        offset = e.bufferOffset;
        size = e.bufferSize;
      }

      (p + i).ref
        ..binding = binding
        ..resource = resource.objectPtr.cast<wgpu.WGpuDawnObject>()
        ..bufferBindOffset = offset
        ..bufferBindSize = size;
    }

    final o = libwebgpu.wgpu_device_create_bind_group(
        parent!.objectPtr, layout.object, p, numEntries);

    setObject(o);

    malloc.free(p);
  }
}
