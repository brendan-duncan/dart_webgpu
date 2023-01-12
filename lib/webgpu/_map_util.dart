import 'bind_group_entry.dart';
import 'bind_group_layout_entry.dart';
import 'blend_component.dart';
import 'blend_state.dart';
import 'buffer_binding_layout.dart';
import 'color_target_state.dart';
import 'compute_pass_descriptor.dart';
import 'compute_pipeline_descriptor.dart';
import 'depth_stencil_state.dart';
import 'fragment_state.dart';
import 'image_copy_buffer.dart';
import 'image_copy_texture.dart';
import 'image_data_layout.dart';
import 'multisample_state.dart';
import 'primitive_state.dart';
import 'render_pass_color_attachment.dart';
import 'render_pass_depth_stencil_attachment.dart';
import 'render_pass_descriptor.dart';
import 'render_pipeline_descriptor.dart';
import 'sampler_binding_layout.dart';
import 'stencil_face_state.dart';
import 'storage_texture_binding_layout.dart';
import 'texture_binding_layout.dart';
import 'timestamp_write.dart';
import 'vertex_attribute.dart';
import 'vertex_buffer_layout.dart';
import 'vertex_state.dart';

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
    if (T == BindGroupEntry) {
      return BindGroupEntry.fromMap(object) as T;
    }
    if (T == BindGroupLayoutEntry) {
      return BindGroupLayoutEntry.fromMap(object) as T;
    }
    if (T == BlendComponent) {
      return BlendComponent.fromMap(object) as T;
    }
    if (T == BlendState) {
      return BlendState.fromMap(object) as T;
    }
    if (T == BufferBindingLayout) {
      return BufferBindingLayout.fromMap(object) as T;
    }
    if (T == ColorTargetState) {
      return ColorTargetState.fromMap(object) as T;
    }
    if (T == ComputePassDescriptor) {
      return ComputePassDescriptor.fromMap(object) as T;
    }
    if (T == ComputePipelineDescriptor) {
      return ComputePipelineDescriptor.fromMap(object) as T;
    }
    if (T == DepthStencilState) {
      return DepthStencilState.fromMap(object) as T;
    }
    if (T == FragmentState) {
      return FragmentState.fromMap(object) as T;
    }
    if (T == ImageCopyBuffer) {
      return ImageCopyBuffer.fromMap(object) as T;
    }
    if (T == ImageCopyTexture) {
      return ImageCopyTexture.fromMap(object) as T;
    }
    if (T == ImageDataLayout) {
      return ImageDataLayout.fromMap(object) as T;
    }
    if (T == MultisampleState) {
      return MultisampleState.fromMap(object) as T;
    }
    if (T == PrimitiveState) {
      return PrimitiveState.fromMap(object) as T;
    }
    if (T == RenderPassColorAttachment) {
      return RenderPassColorAttachment.fromMap(object) as T;
    }
    if (T == RenderPassDepthStencilAttachment) {
      return RenderPassDepthStencilAttachment.fromMap(object) as T;
    }
    if (T == RenderPassDescriptor) {
      return RenderPassDescriptor.fromMap(object) as T;
    }
    if (T == RenderPipelineDescriptor) {
      return RenderPipelineDescriptor.fromMap(object) as T;
    }
    if (T == SamplerBindingLayout) {
      return SamplerBindingLayout.fromMap(object) as T;
    }
    if (T == StencilFaceState) {
      return StencilFaceState.fromMap(object) as T;
    }
    if (T == StorageTextureBindingLayout) {
      return StorageTextureBindingLayout.fromMap(object) as T;
    }
    if (T == TextureBindingLayout) {
      return TextureBindingLayout.fromMap(object) as T;
    }
    if (T == TimestampWrite) {
      return TimestampWrite.fromMap(object) as T;
    }
    if (T == VertexAttribute) {
      return VertexAttribute.fromMap(object) as T;
    }
    if (T == VertexBufferLayout) {
      return VertexBufferLayout.fromMap(object) as T;
    }
    if (T == VertexState) {
      return VertexState.fromMap(object) as T;
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
