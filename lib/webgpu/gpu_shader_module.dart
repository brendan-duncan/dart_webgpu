import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import '../ffi/wgpu_library.dart';
import 'gpu_device.dart';
import 'gpu_object.dart';

/// A reference to an internal shader module object.
class GPUShaderModule extends GPUObjectBase<wgpu.WGpuShaderModule> {
  GPUShaderModule(GPUDevice device,
      {required String
          code /*, Map<String, wgpu.WGpuPipelineLayout>? hints*/}) {
    final p = calloc<wgpu.WGpuShaderModuleDescriptor>();
    p.ref.code = code.toNativeUtf8().cast<Char>();
    // TODO: WGpuShaderModuleDescriptor hints

    final obj = libwebgpu.wgpu_device_create_shader_module(device.object, p);
    setObject(obj);
    device.addDependent(this);

    calloc
      ..free(p.ref.code)
      ..free(p);
  }

  @override
  String toString() => 'ShaderModule';
}
