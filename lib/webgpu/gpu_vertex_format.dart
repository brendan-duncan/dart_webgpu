import '../ffi/ffi_webgpu.dart' as wgpu;

/// The VertexFormat of a vertex attribute indicates how data from a vertex
/// buffer will be interpreted and exposed to the shader. The name of the format
/// specifies the order of components, bits per component, and vertex data type
/// for the component.
enum GPUVertexFormat {
  undefined,
  uint8x2,
  uint8x4,
  sint8x2,
  sint8x4,
  unorm8x2,
  unorm8x4,
  snorm8x2,
  snorm8x4,
  uint16x2,
  uint16x4,
  sint16x2,
  sint16x4,
  unorm16x2,
  unorm16x4,
  snorm16x2,
  snorm16x4,
  float16x2,
  float16x4,
  float32,
  float32x2,
  float32x3,
  float32x4,
  uint32,
  uint32x2,
  uint32x3,
  uint32x4,
  sint32,
  sint32x2,
  sint32x3,
  sint32x4;

  static GPUVertexFormat fromString(String s) {
    switch (s) {
      case 'uint8x2':
        return GPUVertexFormat.uint8x2;
      case 'uint8x4':
        return GPUVertexFormat.uint8x4;
      case 'sint8x2':
        return GPUVertexFormat.sint8x2;
      case 'sint8x4':
        return GPUVertexFormat.sint8x4;
      case 'unorm8x2':
        return GPUVertexFormat.unorm8x2;
      case 'unorm8x4':
        return GPUVertexFormat.unorm8x4;
      case 'snorm8x2':
        return GPUVertexFormat.snorm8x2;
      case 'snorm8x4':
        return GPUVertexFormat.snorm8x4;
      case 'uint16x2':
        return GPUVertexFormat.uint16x2;
      case 'uint16x4':
        return GPUVertexFormat.uint16x4;
      case 'sint16x2':
        return GPUVertexFormat.sint16x2;
      case 'sint16x4':
        return GPUVertexFormat.sint16x4;
      case 'unorm16x2':
        return GPUVertexFormat.unorm16x2;
      case 'unorm16x4':
        return GPUVertexFormat.unorm16x4;
      case 'snorm16x2':
        return GPUVertexFormat.snorm16x2;
      case 'snorm16x4':
        return GPUVertexFormat.snorm16x4;
      case 'float16x2':
        return GPUVertexFormat.float16x2;
      case 'float16x4':
        return GPUVertexFormat.float16x4;
      case 'float32':
        return GPUVertexFormat.float32;
      case 'float32x2':
        return GPUVertexFormat.float32x2;
      case 'float32x3':
        return GPUVertexFormat.float32x3;
      case 'float32x4':
        return GPUVertexFormat.float32x4;
      case 'uint32':
        return GPUVertexFormat.uint32;
      case 'uint32x2':
        return GPUVertexFormat.uint32x2;
      case 'uint32x3':
        return GPUVertexFormat.uint32x3;
      case 'uint32x4':
        return GPUVertexFormat.uint32x4;
      case 'sint32':
        return GPUVertexFormat.sint32;
      case 'sint32x2':
        return GPUVertexFormat.sint32x2;
      case 'sint32x3':
        return GPUVertexFormat.sint32x3;
      case 'sint32x4':
        return GPUVertexFormat.sint32x4;
    }
    throw Exception('Invalid value for GPUVertexFormat');
  }

  int get nativeIndex => index == 0
      ? 0
      :
      // lib_webgpu vertexFormat enum starts at 95
      index + wgpu.WGPU_VERTEX_FORMAT_UINT8X2 - 1;
}
