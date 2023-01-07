import 'ffi/wgpu_library.dart';

export 'wgpu/adapter.dart';
export 'wgpu/bind_group_layout.dart';
export 'wgpu/buffer.dart';
export 'wgpu/buffer_binding_type.dart';
export 'wgpu/buffer_range.dart';
export 'wgpu/buffer_usage.dart';
export 'wgpu/command_buffer.dart';
export 'wgpu/command_encoder.dart';
export 'wgpu/compute_pass_encoder.dart';
export 'wgpu/compute_pipeline.dart';
export 'wgpu/device.dart';
export 'wgpu/error_filter.dart';
export 'wgpu/error_type.dart';
export 'wgpu/extent_3d.dart';
export 'wgpu/features.dart';
export 'wgpu/limits.dart';
export 'wgpu/map_mode.dart';
export 'wgpu/mapped_state.dart';
export 'wgpu/pipeline_layout.dart';
export 'wgpu/power_preference.dart';
export 'wgpu/queue.dart';
export 'wgpu/shader_module.dart';
export 'wgpu/shader_state.dart';
export 'wgpu/wgpu_object.dart';

/// Call initializeWebGPU(debug: true) prior to using any WebGPU commands
/// to have it load the Debug library instead of the Release library.
void initializeWebGPU({bool debug = false }) {
  WGpuLibrary.initialize(debug: debug);
}
