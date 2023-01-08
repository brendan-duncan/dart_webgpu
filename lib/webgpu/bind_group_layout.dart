import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'buffer_binding_type.dart';
import 'device.dart';
import 'shader_state.dart';
import 'wgpu_object.dart';

/// A BindGroupLayout defines the interface between a set of resources bound in
/// a BindGroup and their accessibility in shader stages.
///
/// BindGroupLayouts are created from a Device through the
/// Device.createBindGroupLayout method.
class BindGroupLayout extends WGpuObject<wgpu.WGpuBindGroupLayout> {
  final Device device;

  BindGroupLayout(this.device, {required List<Map<String, Object>> entries}) {
    device.addDependent(this);

    final sizeofEntry = sizeOf<wgpu.WGpuBindGroupLayoutEntry>();
    final numEntries = entries.length;

    final p = malloc
        .allocate<wgpu.WGpuBindGroupLayoutEntry>(sizeofEntry * numEntries);

    for (var i = 0; i < numEntries; ++i) {
      final e = entries[i];

      if (!e.containsKey('binding') || e['binding'] is! int) {
        throw Exception('Invalid binding for BindGroupLayout entry $i');
      }
      if (!e.containsKey('visibility') || e['visibility'] is! ShaderState) {
        throw Exception('Invalid visibility for BindGroupLayout entry $i');
      }

      final ref = p.elementAt(i).ref
        ..binding = e['binding']! as int
        ..visibility = (e['visibility']! as ShaderState).value;

      if (e['buffer'] != null) {
        final b = e['buffer'] as Map<String, Object>;

        if (b['type'] is! BufferBindingType) {
          throw Exception('Invalid type for BindGroupLayout.buffer entry $i');
        }

        final type = (b['type']! as BufferBindingType).index;
        final hdo = b['hasDynamicOffset'];
        final hasDynamicOffset = hdo is bool
            ? hdo
                ? 1
                : 0
            : hdo is int
                ? hdo
                : 0;
        final mbs = b['minBindingSize'];
        final minBindingSize = mbs is int ? mbs : 0;

        ref.type = wgpu.WGPU_BIND_GROUP_LAYOUT_TYPE_BUFFER;
        ref.layout.buffer.type = type;
        ref.layout.buffer.hasDynamicOffset = hasDynamicOffset;
        ref.layout.buffer.minBindingSize = minBindingSize;
      }
    }

    final o = libwebgpu.wgpu_device_create_bind_group_layout(
        device.object, p, numEntries);

    setObject(o);

    malloc.free(p);
  }
}
