library webgpu;

import 'ffi/wgpu_config.dart';
import 'ffi/wgpu_library.dart';

export 'ffi/wgpu_config.dart';
export 'webgpu/gpu_adapter.dart';
export 'webgpu/gpu_address_mode.dart';
export 'webgpu/gpu_bind_group.dart';
export 'webgpu/gpu_bind_group_entry.dart';
export 'webgpu/gpu_bind_group_layout.dart';
export 'webgpu/gpu_bind_group_layout_entry.dart';
export 'webgpu/gpu_blend_component.dart';
export 'webgpu/gpu_blend_factor.dart';
export 'webgpu/gpu_blend_operation.dart';
export 'webgpu/gpu_blend_state.dart';
export 'webgpu/gpu_buffer.dart';
export 'webgpu/gpu_buffer_binding.dart';
export 'webgpu/gpu_buffer_binding_layout.dart';
export 'webgpu/gpu_buffer_binding_type.dart';
export 'webgpu/gpu_buffer_range.dart';
export 'webgpu/gpu_buffer_usage.dart';
export 'webgpu/gpu_color_target_state.dart';
export 'webgpu/gpu_color_write.dart';
export 'webgpu/gpu_command_buffer.dart';
export 'webgpu/gpu_command_encoder.dart';
export 'webgpu/gpu_compare_function.dart';
export 'webgpu/gpu_compute_pass_descriptor.dart';
export 'webgpu/gpu_compute_pass_encoder.dart';
export 'webgpu/gpu_compute_pipeline.dart';
export 'webgpu/gpu_cull_mode.dart';
export 'webgpu/gpu_depth_stencil_state.dart';
export 'webgpu/gpu_device.dart';
export 'webgpu/gpu_device_lost_reason.dart';
export 'webgpu/gpu_error_filter.dart';
export 'webgpu/gpu_error_type.dart';
export 'webgpu/gpu_external_texture_binding_layout.dart';
export 'webgpu/gpu_features.dart';
export 'webgpu/gpu_filter_mode.dart';
export 'webgpu/gpu_fragment_state.dart';
export 'webgpu/gpu_front_face.dart';
export 'webgpu/gpu_image_copy_buffer.dart';
export 'webgpu/gpu_image_copy_texture.dart';
export 'webgpu/gpu_image_data_layout.dart';
export 'webgpu/gpu_index_format.dart';
export 'webgpu/gpu_limits.dart';
export 'webgpu/gpu_load_op.dart';
export 'webgpu/gpu_map_mode.dart';
export 'webgpu/gpu_mapped_state.dart';
export 'webgpu/gpu_multisample_state.dart';
export 'webgpu/gpu_object.dart';
export 'webgpu/gpu_pipeline_layout.dart';
export 'webgpu/gpu_power_preference.dart';
export 'webgpu/gpu_primitive_state.dart';
export 'webgpu/gpu_primitive_topology.dart';
export 'webgpu/gpu_query_set.dart';
export 'webgpu/gpu_query_type.dart';
export 'webgpu/gpu_queue.dart';
export 'webgpu/gpu_render_pass_color_attachment.dart';
export 'webgpu/gpu_render_pass_depth_stencil_attachment.dart';
export 'webgpu/gpu_render_pass_descriptor.dart';
export 'webgpu/gpu_render_pass_encoder.dart';
export 'webgpu/gpu_render_pipeline.dart';
export 'webgpu/gpu_render_pipeline_descriptor.dart';
export 'webgpu/gpu_sampler.dart';
export 'webgpu/gpu_sampler_binding_layout.dart';
export 'webgpu/gpu_sampler_binding_type.dart';
export 'webgpu/gpu_shader_module.dart';
export 'webgpu/gpu_shader_stage.dart';
export 'webgpu/gpu_stencil_face_state.dart';
export 'webgpu/gpu_stencil_operation.dart';
export 'webgpu/gpu_storage_texture_access.dart';
export 'webgpu/gpu_storage_texture_binding_layout.dart';
export 'webgpu/gpu_store_op.dart';
export 'webgpu/gpu_texture.dart';
export 'webgpu/gpu_texture_aspect.dart';
export 'webgpu/gpu_texture_binding_layout.dart';
export 'webgpu/gpu_texture_dimension.dart';
export 'webgpu/gpu_texture_format.dart';
export 'webgpu/gpu_texture_sample_type.dart';
export 'webgpu/gpu_texture_usage.dart';
export 'webgpu/gpu_texture_view.dart';
export 'webgpu/gpu_texture_view_dimension.dart';
export 'webgpu/gpu_timestamp_location.dart';
export 'webgpu/gpu_timestamp_write.dart';
export 'webgpu/gpu_vertex_attribute.dart';
export 'webgpu/gpu_vertex_buffer_layout.dart';
export 'webgpu/gpu_vertex_format.dart';
export 'webgpu/gpu_vertex_state.dart';
export 'webgpu/gpu_vertex_step_mode.dart';

export 'window/gpu_window.dart';
export 'window/gpu_window_context.dart';

/// Ensure the WebGPU library is loaded. This will be automatically
/// called by Adapter.request, but should be called explicitly if
/// you create a Window before an Adapter, as in `await webgpu.initialize();`.
/// {config} lets you load the debug or releaseDebug builds if they are
/// available (from building libwebgpu locally).
Future<void> initializeWebGPU({WGpuConfig? config}) async {
  await WGpuLibrary.get().initialize(config: config ?? WGpuConfig.release);
}
