import 'gpu_address_mode.dart';
import 'gpu_bind_group_entry.dart';
import 'gpu_bind_group_layout_entry.dart';
import 'gpu_blend_component.dart';
import 'gpu_blend_factor.dart';
import 'gpu_blend_operation.dart';
import 'gpu_blend_state.dart';
import 'gpu_buffer_binding_layout.dart';
import 'gpu_buffer_binding_type.dart';
import 'gpu_color_target_state.dart';
import 'gpu_compare_function.dart';
import 'gpu_compute_pass_descriptor.dart';
import 'gpu_compute_pipeline_descriptor.dart';
import 'gpu_cull_mode.dart';
import 'gpu_depth_stencil_state.dart';
import 'gpu_device_lost_reason.dart';
import 'gpu_error_filter.dart';
import 'gpu_error_type.dart';
import 'gpu_filter_mode.dart';
import 'gpu_fragment_state.dart';
import 'gpu_front_face.dart';
import 'gpu_image_copy_buffer.dart';
import 'gpu_image_copy_texture.dart';
import 'gpu_image_data_layout.dart';
import 'gpu_index_format.dart';
import 'gpu_load_op.dart';
import 'gpu_mapped_state.dart';
import 'gpu_multisample_state.dart';
import 'gpu_power_preference.dart';
import 'gpu_primitive_state.dart';
import 'gpu_primitive_topology.dart';
import 'gpu_query_type.dart';
import 'gpu_render_pass_color_attachment.dart';
import 'gpu_render_pass_depth_stencil_attachment.dart';
import 'gpu_render_pass_descriptor.dart';
import 'gpu_render_pipeline_descriptor.dart';
import 'gpu_sampler_binding_layout.dart';
import 'gpu_sampler_binding_type.dart';
import 'gpu_stencil_face_state.dart';
import 'gpu_stencil_operation.dart';
import 'gpu_storage_texture_access.dart';
import 'gpu_storage_texture_binding_layout.dart';
import 'gpu_store_op.dart';
import 'gpu_texture_aspect.dart';
import 'gpu_texture_binding_layout.dart';
import 'gpu_texture_dimension.dart';
import 'gpu_texture_format.dart';
import 'gpu_texture_sample_type.dart';
import 'gpu_texture_view_dimension.dart';
import 'gpu_timestamp_location.dart';
import 'gpu_timestamp_write.dart';
import 'gpu_vertex_attribute.dart';
import 'gpu_vertex_buffer_layout.dart';
import 'gpu_vertex_format.dart';
import 'gpu_vertex_state.dart';
import 'gpu_vertex_step_mode.dart';

T mapValueRequired<T>(Object? object) {
  if (object == null) {
    throw Exception('Invalid data for $T');
  }
  if (object is String) {
    if (T == GPUAddressMode) {
      return GPUAddressMode.fromString(object) as T;
    }
    if (T == GPUBlendFactor) {
      return GPUBlendFactor.fromString(object) as T;
    }
    if (T == GPUBlendOperation) {
      return GPUBlendOperation.fromString(object) as T;
    }
    if (T == GPUBufferBindingType) {
      return GPUBufferBindingType.fromString(object) as T;
    }
    if (T == GPUCompareFunction) {
      return GPUCompareFunction.fromString(object) as T;
    }
    if (T == GPUCullMode) {
      return GPUCullMode.fromString(object) as T;
    }
    if (T == GPUDeviceLostReason) {
      return GPUDeviceLostReason.fromString(object) as T;
    }
    if (T == GPUErrorFilter) {
      return GPUErrorFilter.fromString(object) as T;
    }
    if (T == GPUErrorType) {
      return GPUErrorType.fromString(object) as T;
    }
    if (T == GPUFilterMode) {
      return GPUFilterMode.fromString(object) as T;
    }
    if (T == GPUFrontFace) {
      return GPUFrontFace.fromString(object) as T;
    }
    if (T == GPUIndexFormat) {
      return GPUIndexFormat.fromString(object) as T;
    }
    if (T == GPULoadOp) {
      return GPULoadOp.fromString(object) as T;
    }
    if (T == GPUMappedState) {
      return GPUMappedState.fromString(object) as T;
    }
    if (T == GPUPowerPreference) {
      return GPUPowerPreference.fromString(object) as T;
    }
    if (T == GPUPrimitiveTopology) {
      return GPUPrimitiveTopology.fromString(object) as T;
    }
    if (T == GPUQueryType) {
      return GPUQueryType.fromString(object) as T;
    }
    if (T == GPUSamplerBindingType) {
      return GPUSamplerBindingType.fromString(object) as T;
    }
    if (T == GPUStencilOperation) {
      return GPUStencilOperation.fromString(object) as T;
    }
    if (T == GPUStorageTextureAccess) {
      return GPUStorageTextureAccess.fromString(object) as T;
    }
    if (T == GPUStoreOp) {
      return GPUStoreOp.fromString(object) as T;
    }
    if (T == GPUTextureAspect) {
      return GPUTextureAspect.fromString(object) as T;
    }
    if (T == GPUTextureDimension) {
      return GPUTextureDimension.fromString(object) as T;
    }
    if (T == GPUTextureFormat) {
      return GPUTextureFormat.fromString(object) as T;
    }
    if (T == GPUTextureSampleType) {
      return GPUTextureSampleType.fromString(object) as T;
    }
    if (T == GPUTextureViewDimension) {
      return GPUTextureViewDimension.fromString(object) as T;
    }
    if (T == GPUTimestampLocation) {
      return GPUTimestampLocation.fromString(object) as T;
    }
    if (T == GPUVertexFormat) {
      return GPUVertexFormat.fromString(object) as T;
    }
    if (T == GPUVertexStepMode) {
      return GPUVertexStepMode.fromString(object) as T;
    }
  }
  if (object is! T) {
    throw Exception('Invalid data for $T');
  }
  return object as T;
}

T mapValue<T>(Object? object, T defaultValue) {
  if (object == null) {
    return defaultValue;
  }
  return mapValueRequired<T>(object);
}

T? mapValueNullable<T>(Object? object) {
  if (object == null) {
    return null;
  }
  return mapValueRequired<T>(object);
}

T? mapObjectNullable<T>(Object? object) {
  if (object == null) {
    return null;
  }
  if (object is T) {
    return object as T;
  }
  if (object is Map<String, Object>) {
    if (T == GPUBindGroupEntry) {
      return GPUBindGroupEntry.fromMap(object) as T;
    }
    if (T == GPUBindGroupLayoutEntry) {
      return GPUBindGroupLayoutEntry.fromMap(object) as T;
    }
    if (T == GPUBlendComponent) {
      return GPUBlendComponent.fromMap(object) as T;
    }
    if (T == GPUBlendState) {
      return GPUBlendState.fromMap(object) as T;
    }
    if (T == GPUBufferBindingLayout) {
      return GPUBufferBindingLayout.fromMap(object) as T;
    }
    if (T == GpuColorTargetState) {
      return GpuColorTargetState.fromMap(object) as T;
    }
    if (T == GPUComputePassDescriptor) {
      return GPUComputePassDescriptor.fromMap(object) as T;
    }
    if (T == GPUComputePipelineDescriptor) {
      return GPUComputePipelineDescriptor.fromMap(object) as T;
    }
    if (T == GPUDepthStencilState) {
      return GPUDepthStencilState.fromMap(object) as T;
    }
    if (T == GPUFragmentState) {
      return GPUFragmentState.fromMap(object) as T;
    }
    if (T == GPUImageCopyBuffer) {
      return GPUImageCopyBuffer.fromMap(object) as T;
    }
    if (T == GPUImageCopyTexture) {
      return GPUImageCopyTexture.fromMap(object) as T;
    }
    if (T == GPUImageDataLayout) {
      return GPUImageDataLayout.fromMap(object) as T;
    }
    if (T == GPUMultisampleState) {
      return GPUMultisampleState.fromMap(object) as T;
    }
    if (T == GPUPrimitiveState) {
      return GPUPrimitiveState.fromMap(object) as T;
    }
    if (T == GPURenderPassColorAttachment) {
      return GPURenderPassColorAttachment.fromMap(object) as T;
    }
    if (T == GPURenderPassDepthStencilAttachment) {
      return GPURenderPassDepthStencilAttachment.fromMap(object) as T;
    }
    if (T == GPURenderPassDescriptor) {
      return GPURenderPassDescriptor.fromMap(object) as T;
    }
    if (T == GPURenderPipelineDescriptor) {
      return GPURenderPipelineDescriptor.fromMap(object) as T;
    }
    if (T == GPUSamplerBindingLayout) {
      return GPUSamplerBindingLayout.fromMap(object) as T;
    }
    if (T == GPUStencilFaceState) {
      return GPUStencilFaceState.fromMap(object) as T;
    }
    if (T == GPUStorageTextureBindingLayout) {
      return GPUStorageTextureBindingLayout.fromMap(object) as T;
    }
    if (T == GPUTextureBindingLayout) {
      return GPUTextureBindingLayout.fromMap(object) as T;
    }
    if (T == GPUTimestampWrite) {
      return GPUTimestampWrite.fromMap(object) as T;
    }
    if (T == GPUVertexAttribute) {
      return GPUVertexAttribute.fromMap(object) as T;
    }
    if (T == GPUVertexBufferLayout) {
      return GPUVertexBufferLayout.fromMap(object) as T;
    }
    if (T == GPUVertexState) {
      return GPUVertexState.fromMap(object) as T;
    }
  }
  throw Exception('Invalid data for $T.');
}

T mapObject<T>(Object? object) {
  final o = mapObjectNullable<T>(object);
  if (o == null) {
    throw Exception('Invalid data for $T');
  }
  return o;
}

List<T>? mapListNullable<T>(Object? object) {
  if (object == null) {
    return null;
  }
  if (object is List<T>) {
    return object;
  }
  if (object is! List<Map<String, Object>>) {
    throw Exception('Invalid data for $T');
  }
  return List<T>.generate(object.length, (i) => mapObject<T>(object[i]));
}

List<T> mapList<T>(Object? object) {
  final l = mapListNullable<T>(object);
  if (l == null) {
    throw Exception('Invalid data for $T');
  }
  return l;
}
