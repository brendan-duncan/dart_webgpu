import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'device.dart';
import 'shader_module_descriptor.dart';
import 'wgpu_object.dart';

class ShaderModule extends WGpuObject<wgpu.WGpuShaderModule> {
  final Device device;

  ShaderModule(this.device, ShaderModuleDescriptor descriptor) {
    final p = calloc<wgpu.WGpuShaderModuleDescriptor>();
    p.ref.code = descriptor.code.toNativeUtf8().cast<Char>();
    // TODO: WGpuShaderModuleDescriptor hints
    final obj = library.wgpu_device_create_shader_module(device.object, p);
    calloc.free(p.ref.code);
    calloc.free(p);

    setObject(obj);

    device.addDependent(this);
  }
}
