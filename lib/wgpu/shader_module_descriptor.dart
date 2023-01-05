import 'dart:ffi';

import 'package:ffi/ffi.dart';
import '../ffi/ffi_webgpu.dart' as wgpu;
import 'shader_module_compilation_hint.dart';

class ShaderModuleDescriptor {
  String code;
  List<ShaderModuleCompilationHint>? hints;

  ShaderModuleDescriptor({ required this.code, this.hints });

  Pointer<wgpu.WGpuShaderModuleDescriptor> toWgpu() {
    final l = calloc<wgpu.WGpuShaderModuleDescriptor>();
    l.ref.code = code.toNativeUtf8().cast<Char>();
    // TODO: WGpuShaderModuleDescriptor hints
    return l;
  }
}
