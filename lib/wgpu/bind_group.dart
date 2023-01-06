import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'bind_group_layout.dart';
import 'buffer.dart';
import 'device.dart';
import 'wgpu_object.dart';

class BindGroup extends WGpuObject<wgpu.WGpuBindGroup> {
  Device device;

  BindGroup(this.device,
      {required BindGroupLayout layout,
      required List<Map<String, Object>> entries}) {
    device.addDependent(this);
    print(layout);
    print(entries);

    final sizeofEntry = sizeOf<wgpu.WGpuBindGroupEntry>();
    final numEntries = entries.length;
    final p = malloc<wgpu.WGpuBindGroupEntry>(sizeofEntry * numEntries);

    for (var i = 0; i < numEntries; ++i) {
      final e = entries[i];
      if (e['binding'] is! int) {
        throw Exception('Invalid binding for BindGroupEntry $i');
      }
      final binding = e['binding']! as int;
      final resource = e['resource'];

      if (resource is Map<String, Object>) {
        if (resource['buffer'] is! Buffer) {
          throw Exception('Invalid buffer binding for BindGroupEntry $i');
        }
        final buffer = resource['buffer'] as Buffer;
        final offset = resource['offset'] ?? 0;
        final size = resource['size'] ?? 0;
        p.elementAt(i).ref
          ..binding = binding
          ..resource = buffer.objectPtr.cast<wgpu.WGpuObjectDawn>()
          ..bufferBindOffset = offset as int
          ..bufferBindSize = size as int;
      } else if (resource is WGpuObjectBase) {
        p.elementAt(i).ref
          ..binding = binding
          ..resource = resource.objectPtr.cast<wgpu.WGpuObjectDawn>();
      } else {
        throw Exception('Invalid resource for BindGroupEntry $i');
      }
    }

    final o = libwebgpu.wgpu_device_create_bind_group(
        device.object, layout.object, p, numEntries);

    setObject(o);

    malloc.free(p);
  }
}
