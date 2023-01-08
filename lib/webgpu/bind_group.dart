import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'bind_group_entry.dart';
import 'bind_group_layout.dart';
import 'device.dart';
import 'wgpu_object.dart';

/// A BindGroup defines a set of resources to be bound together in a group and
/// how the resources are used in shader stages.
///
/// BindGroups are created from Device.createBindGroup().
class BindGroup extends WGpuObject<wgpu.WGpuBindGroup> {
  final Device device;

  /// Create a BindGroup from the given [device].
  /// [layout] is the BindGroupLayout the entries of this bind group will
  /// conform to.
  /// [entries] is the list of entries describing the resources to expose to
  /// the shader for each binding described by the layout.
  BindGroup(this.device,
      {required BindGroupLayout layout,
      required List<BindGroupEntry> entries}) {
    device.addDependent(this);

    final sizeofEntry = sizeOf<wgpu.WGpuBindGroupEntry>();
    final numEntries = entries.length;
    final p = malloc<wgpu.WGpuBindGroupEntry>(sizeofEntry * numEntries);

    for (var i = 0; i < numEntries; ++i) {
      final e = entries[i];
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
