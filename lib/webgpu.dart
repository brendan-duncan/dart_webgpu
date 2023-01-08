import 'ffi/wgpu_library.dart';

export 'webgpu/adapter.dart';
export 'webgpu/address_mode.dart';
export 'webgpu/bind_group.dart';
export 'webgpu/bind_group_layout.dart';
export 'webgpu/blend_component.dart';
export 'webgpu/blend_factor.dart';
export 'webgpu/blend_operation.dart';
export 'webgpu/blend_state.dart';
export 'webgpu/buffer.dart';
export 'webgpu/buffer_binding_type.dart';
export 'webgpu/buffer_range.dart';
export 'webgpu/buffer_usage.dart';
export 'webgpu/color_target_state.dart';
export 'webgpu/color_write.dart';
export 'webgpu/command_buffer.dart';
export 'webgpu/command_encoder.dart';
export 'webgpu/compare_function.dart';
export 'webgpu/compute_pass_encoder.dart';
export 'webgpu/compute_pipeline.dart';
export 'webgpu/cull_mode.dart';
export 'webgpu/depth_stencil_state.dart';
export 'webgpu/device.dart';
export 'webgpu/device_lost_info.dart';
export 'webgpu/error_filter.dart';
export 'webgpu/error_type.dart';
export 'webgpu/features.dart';
export 'webgpu/filter_mode.dart';
export 'webgpu/fragment_state.dart';
export 'webgpu/front_face.dart';
export 'webgpu/index_format.dart';
export 'webgpu/limits.dart';
export 'webgpu/map_mode.dart';
export 'webgpu/mapped_state.dart';
export 'webgpu/multisample_state.dart';
export 'webgpu/pipeline_layout.dart';
export 'webgpu/power_preference.dart';
export 'webgpu/primitive_state.dart';
export 'webgpu/primitive_topology.dart';
export 'webgpu/queue.dart';
export 'webgpu/render_pipeline.dart';
export 'webgpu/render_pipeline_descriptor.dart';
export 'webgpu/sampler.dart';
export 'webgpu/shader_module.dart';
export 'webgpu/shader_state.dart';
export 'webgpu/stencil_face_state.dart';
export 'webgpu/stencil_operation.dart';
export 'webgpu/texture.dart';
export 'webgpu/texture_aspect.dart';
export 'webgpu/texture_dimension.dart';
export 'webgpu/texture_format.dart';
export 'webgpu/texture_usage.dart';
export 'webgpu/texture_view.dart';
export 'webgpu/texture_view_dimension.dart';
export 'webgpu/vertex_attribute.dart';
export 'webgpu/vertex_buffer_layout.dart';
export 'webgpu/vertex_format.dart';
export 'webgpu/vertex_state.dart';
export 'webgpu/vertex_step_mode.dart';
export 'webgpu/wgpu_object.dart';

/// Call initializeWebGPU(debug: true) prior to using any WebGPU commands
/// to have it load the Debug library instead of the Release library.
void initializeWebGPU({bool debug = false}) {
  WGpuLibrary.initialize(debug: debug);
}
