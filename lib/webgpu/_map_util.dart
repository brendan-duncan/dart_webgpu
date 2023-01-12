import 'gpu_bind_group_entry.dart';
import 'gpu_bind_group_layout_entry.dart';
import 'gpu_blend_component.dart';
import 'gpu_blend_state.dart';
import 'gpu_buffer_binding_layout.dart';
import 'gpu_color_target_state.dart';
import 'gpu_compute_pass_descriptor.dart';
import 'gpu_compute_pipeline_descriptor.dart';
import 'gpu_depth_stencil_state.dart';
import 'gpu_fragment_state.dart';
import 'gpu_image_copy_buffer.dart';
import 'gpu_image_copy_texture.dart';
import 'gpu_image_data_layout.dart';
import 'gpu_multisample_state.dart';
import 'gpu_primitive_state.dart';
import 'gpu_render_pass_color_attachment.dart';
import 'gpu_render_pass_depth_stencil_attachment.dart';
import 'gpu_render_pass_descriptor.dart';
import 'gpu_render_pipeline_descriptor.dart';
import 'gpu_sampler_binding_layout.dart';
import 'gpu_stencil_face_state.dart';
import 'gpu_storage_texture_binding_layout.dart';
import 'gpu_texture_binding_layout.dart';
import 'gpu_timestamp_write.dart';
import 'gpu_vertex_attribute.dart';
import 'gpu_vertex_buffer_layout.dart';
import 'gpu_vertex_state.dart';

T getMapValue<T>(Object? object, T defaultValue) {
  if (object == null) {
    return defaultValue;
  }
  if (object is! T) {
    throw Exception('Invalid data for $T');
  }
  return object as T;
}

T getMapValueRequired<T>(Object? object) {
  if (object == null) {
    throw Exception('Invalid data for $T');
  }
  if (object is! T) {
    throw Exception('Invalid data for $T');
  }
  return object as T;
}

T? getMapObjectNullable<T>(Object? object) {
  if (object == null) {
    return null;
  }
  if (object is T) {
    return object as T;
  }
  if (object is Map<String, Object>) {
    if (T == GpuBindGroupEntry) {
      return GpuBindGroupEntry.fromMap(object) as T;
    }
    if (T == GpuBindGroupLayoutEntry) {
      return GpuBindGroupLayoutEntry.fromMap(object) as T;
    }
    if (T == GpuBlendComponent) {
      return GpuBlendComponent.fromMap(object) as T;
    }
    if (T == GpuBlendState) {
      return GpuBlendState.fromMap(object) as T;
    }
    if (T == GpuBufferBindingLayout) {
      return GpuBufferBindingLayout.fromMap(object) as T;
    }
    if (T == GpuColorTargetState) {
      return GpuColorTargetState.fromMap(object) as T;
    }
    if (T == GpuComputePassDescriptor) {
      return GpuComputePassDescriptor.fromMap(object) as T;
    }
    if (T == GpuComputePipelineDescriptor) {
      return GpuComputePipelineDescriptor.fromMap(object) as T;
    }
    if (T == GpuDepthStencilState) {
      return GpuDepthStencilState.fromMap(object) as T;
    }
    if (T == GpuFragmentState) {
      return GpuFragmentState.fromMap(object) as T;
    }
    if (T == GpuImageCopyBuffer) {
      return GpuImageCopyBuffer.fromMap(object) as T;
    }
    if (T == GpuImageCopyTexture) {
      return GpuImageCopyTexture.fromMap(object) as T;
    }
    if (T == GpuImageDataLayout) {
      return GpuImageDataLayout.fromMap(object) as T;
    }
    if (T == GpuMultisampleState) {
      return GpuMultisampleState.fromMap(object) as T;
    }
    if (T == GpuPrimitiveState) {
      return GpuPrimitiveState.fromMap(object) as T;
    }
    if (T == GpuRenderPassColorAttachment) {
      return GpuRenderPassColorAttachment.fromMap(object) as T;
    }
    if (T == GpuRenderPassDepthStencilAttachment) {
      return GpuRenderPassDepthStencilAttachment.fromMap(object) as T;
    }
    if (T == GpuRenderPassDescriptor) {
      return GpuRenderPassDescriptor.fromMap(object) as T;
    }
    if (T == GpuRenderPipelineDescriptor) {
      return GpuRenderPipelineDescriptor.fromMap(object) as T;
    }
    if (T == GpuSamplerBindingLayout) {
      return GpuSamplerBindingLayout.fromMap(object) as T;
    }
    if (T == GpuStencilFaceState) {
      return GpuStencilFaceState.fromMap(object) as T;
    }
    if (T == GpuStorageTextureBindingLayout) {
      return GpuStorageTextureBindingLayout.fromMap(object) as T;
    }
    if (T == GpuTextureBindingLayout) {
      return GpuTextureBindingLayout.fromMap(object) as T;
    }
    if (T == GpuTimestampWrite) {
      return GpuTimestampWrite.fromMap(object) as T;
    }
    if (T == GpuVertexAttribute) {
      return GpuVertexAttribute.fromMap(object) as T;
    }
    if (T == GpuVertexBufferLayout) {
      return GpuVertexBufferLayout.fromMap(object) as T;
    }
    if (T == GpuVertexState) {
      return GpuVertexState.fromMap(object) as T;
    }
  }
  throw Exception('Invalid data for $T.');
}

T getMapObject<T>(Object? object) {
  final o = getMapObjectNullable<T>(object);
  if (o == null) {
    throw Exception('Invalid data for $T');
  }
  return o;
}

List<T>? getMapListNullable<T>(Object? object) {
  if (object == null) {
    return null;
  }
  if (object is List<T>) {
    return object;
  }
  if (object is! List<Map<String, Object>>) {
    throw Exception('Invalid data for $T');
  }
  return List<T>.generate(object.length, (i) => getMapObject<T>(object[i]));
}

List<T> getMapList<T>(Object? object) {
  final l = getMapListNullable<T>(object);
  if (l == null) {
    throw Exception('Invalid data for $T');
  }
  return l;
}
