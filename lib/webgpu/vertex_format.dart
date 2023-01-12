import '../ffi/ffi_webgpu.dart' as wgpu;

/// The VertexFormat of a vertex attribute indicates how data from a vertex
/// buffer will be interpreted and exposed to the shader. The name of the format
/// specifies the order of components, bits per component, and vertex data type
/// for the component.
enum VertexFormat {
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

  int get nativeIndex => index == 0 ? 0 :
    // lib_webgpu vertexFormat enum starts at 95
    index + wgpu.WGPU_VERTEX_FORMAT_UINT8X2 - 1;
}
