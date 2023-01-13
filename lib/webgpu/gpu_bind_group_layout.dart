import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_bind_group_layout_entry.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';

/// A BindGroupLayout defines the interface between a set of resources bound in
/// a BindGroup and their accessibility in shader stages.
///
/// BindGroupLayouts are created from a Device through the
/// Device.createBindGroupLayout method.
class GPUBindGroupLayout extends GPUObjectBase<wgpu.WGpuBindGroupLayout> {
  GPUBindGroupLayout.native(GPUDevice? device, wgpu.WGpuBindGroupLayout o)
      : super(o, device);

  GPUBindGroupLayout(GPUDevice device, {required List<Object> entries}) {
    device.addDependent(this);

    final sizeofEntry = sizeOf<wgpu.WGpuBindGroupLayoutEntry>();
    final numEntries = entries.length;

    final p = malloc
        .allocate<wgpu.WGpuBindGroupLayoutEntry>(sizeofEntry * numEntries);

    for (var i = 0; i < numEntries; ++i) {
      var e = entries[i];
      if (e is Map<String, Object>) {
        e = GPUBindGroupLayoutEntry.fromMap(e);
      }
      if (e is! GPUBindGroupLayoutEntry) {
        throw Exception('Invalid data for BindGroupLayout entries.');
      }

      final ref = p.elementAt(i).ref
        ..binding = e.binding
        ..visibility = e.visibility.value;

      if (e.buffer != null) {
        final b = e.buffer!;
        ref.type = wgpu.WGPU_BIND_GROUP_LAYOUT_TYPE_BUFFER;
        ref.layout.buffer.type = b.type.nativeIndex;
        ref.layout.buffer.hasDynamicOffset = b.hasDynamicOffset ? 1 : 0;
        ref.layout.buffer.minBindingSize = b.minBindingSize;
      } else if (e.sampler != null) {
        final s = e.sampler!;
        ref.type = wgpu.WGPU_BIND_GROUP_LAYOUT_TYPE_SAMPLER;
        ref.layout.sampler.type = s.type.nativeIndex;
      } else if (e.texture != null) {
        final t = e.texture!;
        ref.type = wgpu.WGPU_BIND_GROUP_LAYOUT_TYPE_TEXTURE;
        ref.layout.texture.viewDimension = t.viewDimension.nativeIndex;
        ref.layout.texture.sampleType = t.sampleType.nativeIndex;
      } else if (e.storageTexture != null) {
        final t = e.storageTexture!;
        ref.type = wgpu.WGPU_BIND_GROUP_LAYOUT_TYPE_STORAGE_TEXTURE;
        ref.layout.storageTexture.viewDimension = t.viewDimension.nativeIndex;
        ref.layout.storageTexture.format = t.format.nativeIndex;
        ref.layout.storageTexture.access = t.access.nativeIndex;
      } else if (e.externalTexture != null) {
        ref.type = wgpu.WGPU_BIND_GROUP_LAYOUT_TYPE_EXTERNAL_TEXTURE;
      }
    }

    final o = libwebgpu.wgpu_device_create_bind_group_layout(
        device.object, p, numEntries);

    setObject(o);

    malloc.free(p);
  }
}
