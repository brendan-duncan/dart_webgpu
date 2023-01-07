import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'bind_group_layout.dart';
import 'device.dart';
import 'wgpu_object.dart';

/// A PipelineLayout defines the mapping between resources of all BindGroup
/// objects set up during command encoding in setBindGroup(), and the shaders
/// of the pipeline set by setPipeline.
class PipelineLayout extends WGpuObject<wgpu.WGpuPipelineLayout> {
  Device device;
  PipelineLayout(this.device, List<BindGroupLayout> layouts) {
    device.addDependent(this);

    final sizeofPtr = sizeOf<wgpu.WGpuBindGroupLayout>();
    final numEntries = layouts.length;
    final p = malloc<wgpu.WGpuBindGroupLayout>(sizeofPtr * numEntries);
    for (var i = 0; i < numEntries; ++i) {
      p.elementAt(i).value = layouts[i].object;
    }
    final o = libwebgpu.wgpu_device_create_pipeline_layout(device.object, p,
        numEntries);
    malloc.free(p);

    setObject(o);
  }
}
