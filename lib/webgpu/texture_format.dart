/// The name of the format specifies the order of components, bits per
/// component, and data type for the component.
///
/// r, g, b, a = red, green, blue, alpha
///
/// unorm = unsigned normalized
///
/// snorm = signed normalized
///
/// uint = unsigned int
///
/// sint = signed int
///
/// float = floating point
///
/// If the format has the Srgb suffix, then sRGB conversions from gamma to
/// linear and vice versa are applied during the reading and writing of color
/// values in the shader. Compressed texture formats are provided by features.
/// Their naming should follow the convention here, with the texture name as a
/// prefix. e.g. etc2-rgba8unorm.
enum TextureFormat {
  // 8-bit formats
  r8unorm,
  r8snorm,
  r8uint,
  r8sint,

  // 16-bit formats
  r16uint,
  r16sint,
  r16float,
  rg8unorm,
  rg8snorm,
  rg8uint,
  rg8sint,

  // 32-bit formats
  r32uint,
  r32sint,
  r32float,
  rg16uint,
  rg16sint,
  rg16float,
  rgba8unorm,
  rgba8unormSrgb,
  rgba8snorm,
  rgba8uint,
  rgba8sint,
  bgra8unorm,
  bgra8unormSrgb,
  // Packed 32-bit formats
  rgb9e5ufloat,
  rgb10a2unorm,
  rg11b10ufloat,

  // 64-bit formats
  rg32uint,
  rg32sint,
  rg32float,
  rgba16uint,
  rgba16sint,
  rgba16float,

  // 128-bit formats
  rgba32uint,
  rgba32sint,
  rgba32float,

  // Depth/stencil formats
  stencil8,
  depth16unorm,
  depth24plus,
  depth24plusStencil8,
  depth32float,
  depth32floatStencil8,

  // BC compressed formats usable if "texture-compression-bc" is both
  // supported by the device/user agent and enabled in requestDevice.
  bc1rgbaunorm,
  bc1rgbaunormSrgb,
  bc2rgbaunorm,
  bc2rgbaunormSrgb,
  bc3rgbaunorm,
  bc3rgbaunormSrgb,
  bc4runorm,
  bc4rsnorm,
  bc5rgunorm,
  bc5rgsnorm,
  bc6hrgbufloat,
  bc6hrgbfloat,
  bc7rgbaunorm,
  bc7rgbaunormSrgb,

  // ETC2 compressed formats usable if "texture-compression-etc2" is both
  // supported by the device/user agent and enabled in requestDevice.
  etc2rgb8unorm,
  etc2rgb8unormSrgb,
  etc2rgb8a1UNorm,
  etc2rgb8a1unormSrgb,
  etc2rgba8unorm,
  etc2rgba8snorm,
  eacr11unorm,
  eacr11snorm,
  eacrg11unorm,
  eacrg11snorm,

  // ASTC compressed formats usable if "texture-compression-astc" is both
  // supported by the device/user agent and enabled in requestDevice.
  astc4x4unorm,
  astc4x4unormSrgb,
  astc5x4unorm,
  astc5x4unormSrgb,
  astc5x5unorm,
  astc5x5unormSrgb,
  astc6x5unorm,
  astc6x5unormSrgb,
  astc6x6unorm,
  astc6x6unormSrgb,
  astc8x5unorm,
  astc8x5unormSrgb,
  astc8x6unorm,
  astc8x6unormSrgb,
  astc8x8unorm,
  astc8x8unormSrgb,
  astc10x5unorm,
  astc10x5unormSrgb,
  astc10x6unorm,
  astc10x6unormSrgb,
  astc10x8unorm,
  astc10x8unormSrgb,
  astc10x10unorm,
  astc10x10unormSrgb,
  astc12x10unorm,
  astc12x10unormSrgb,
  astc12x12unorm,
  astc12x12unormSrgb;

  int get nativeIndex => index + 1;
}
