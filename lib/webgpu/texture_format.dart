/// The name of the format specifies the order of components, bits per
/// component, and data type for the component.
///
/// r, g, b, a = red, green, blue, alpha
///
/// Unorm = unsigned normalized
///
/// Snorm = signed normalized
///
/// Uint = unsigned int
///
/// Sint = signed int
///
/// Float = floating point
///
/// If the format has the Srgb suffix, then sRGB conversions from gamma to
/// linear and vice versa are applied during the reading and writing of color
/// values in the shader. Compressed texture formats are provided by features.
/// Their naming should follow the convention here, with the texture name as a
/// prefix. e.g. etc2-rgba8unorm.
enum TextureFormat {
  undefined,

  // 8-bit formats
  r8Unorm,
  r8Snorm,
  r8Uint,
  r8Sint,

  // 16-bit formats
  r16Uint,
  r16Sint,
  r16Float,
  rg8Unorm,
  rg8Snorm,
  rg8Uint,
  rg8Sint,

  // 32-bit formats
  r32Uint,
  r32Sint,
  r32Float,
  rg16Uint,
  rg16Sint,
  rg16Float,
  rgba8Unorm,
  rgba8UnormSrgb,
  rgba8Snorm,
  rgba8Uint,
  rgba8Sint,
  bgra8Unorm,
  bgra8UnormSrgb,
  // Packed 32-bit formats
  rgb9e5uFloat,
  rgb10a2Unorm,
  rg11b10uFloat,

  // 64-bit formats
  rg32Uint,
  rg32Sint,
  rg32Float,
  rgba16Uint,
  rgba16Sint,
  rgba16Float,

  // 128-bit formats
  rgba32Uint,
  rgba32Sint,
  rgba32Float,

  // Depth/stencil formats
  stencil8,
  depth16Unorm,
  depth24Plus,
  depth24PlusStencil8,
  depth32Float,
  depth32FloatStencil8,

  // BC compressed formats usable if "texture-compression-bc" is both
  // supported by the device/user agent and enabled in requestDevice.
  bc1RgbaUnorm,
  bc1RgbaUnormSrgb,
  bc2RgbaUnorm,
  bc2RgbaUnormSrgb,
  bc3RgbaUnorm,
  bc3RgbaUnormSrgb,
  bc4RUnorm,
  bc4RSnorm,
  bc5RgUnorm,
  bc5RgSnorm,
  bc6hRgbUfloat,
  bc6hRgbFloat,
  bc7RgbaUnorm,
  bc7RgbaUnormSrgb,

  // ETC2 compressed formats usable if "texture-compression-etc2" is both
  // supported by the device/user agent and enabled in requestDevice.
  etc2Rgb8Unorm,
  etc2Rgb8UnormSrgb,
  etc2Rgb8a1UNorm,
  etc2Rgb8a1UnormSrgb,
  etc2Rgba8unorm,
  etc2Rgba8Unorm,
  eacR11Unorm,
  eacR11Snorm,
  eacRg11Unorm,
  eacRg11Snorm,

  // ASTC compressed formats usable if "texture-compression-astc" is both
  // supported by the device/user agent and enabled in requestDevice.
  astc4x4Unorm,
  astc4x4UnormSrgb,
  astc5x4Unorm,
  astc5x4UnormSrgb,
  astc5x5Unorm,
  astc5x5UnormSrgb,
  astc6x5Unorm,
  astc6x5UnormSrgb,
  astc6x6Unorm,
  astc6x6UnormSrgb,
  astc8x5Unorm,
  astc8x5UnormSrgb,
  astc8x6Unorm,
  astc8x6UnormSrgb,
  astc8x8Unorm,
  astc8x8UnormSrgb,
  astc10x5Unorm,
  astc10x5UnormSrgb,
  astc10x6Unorm,
  astc10x6UnormSrgb,
  astc10x8Unorm,
  astc10x8UnormSrgb,
  astc10x10Unorm,
  astc10x10UnormSrgb,
  astc12x10Unorm,
  astc12x10UnormSrgb,
  astc12x12Unorm,
  astc12x12UnormSrgb,
}
