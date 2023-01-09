import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'bind_group_layout_entry.dart';
import 'device.dart';
import 'wgpu_object.dart';

/// A BindGroupLayout defines the interface between a set of resources bound in
/// a BindGroup and their accessibility in shader stages.
///
/// BindGroupLayouts are created from a Device through the
/// Device.createBindGroupLayout method.
class BindGroupLayout extends WGpuObjectBase<wgpu.WGpuBindGroupLayout> {
  final Device device;

  BindGroupLayout(this.device, {required List<BindGroupLayoutEntry> entries}) {
    device.addDependent(this);

    final sizeofEntry = sizeOf<wgpu.WGpuBindGroupLayoutEntry>();
    final numEntries = entries.length;

    final p = malloc
        .allocate<wgpu.WGpuBindGroupLayoutEntry>(sizeofEntry * numEntries);

    for (var i = 0; i < numEntries; ++i) {
      final e = entries[i];

      final ref = p.elementAt(i).ref
        ..binding = e.binding
        ..visibility = e.visibility.value;

      if (e.buffer != null) {
        final b = e.buffer!;
        ref.type = wgpu.WGPU_BIND_GROUP_LAYOUT_TYPE_BUFFER;
        ref.layout.buffer.type = b.type.nativeIndex;
        ref.layout.buffer.hasDynamicOffset = b.hasDynamicOffset ? 1 : 0;
        ref.layout.buffer.minBindingSize = b.minBindingSize;
      }
    }

    final o = libwebgpu.wgpu_device_create_bind_group_layout(
        device.object, p, numEntries);

    setObject(o);

    malloc.free(p);
  }
}
