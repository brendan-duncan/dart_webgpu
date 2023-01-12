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
enum GPUTextureFormat {
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

  // BC compressed formats usable if 'texture-compression-bc' is both
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

  // ETC2 compressed formats usable if 'texture-compression-etc2' is both
  // supported by the device/user agent and enabled in requestDevice.
  etc2Rgb8unorm,
  etc2Rgb8unormSrgb,
  etc2Rgb8a1unorm,
  etc2Rgb8a1unormSrgb,
  etc2Rgba8unorm,
  etc2Rgba8unormSrgb,
  eacR11unorm,
  eacR11snorm,
  eacRg11unorm,
  eacRg11snorm,

  // ASTC compressed formats usable if 'texture-compression-astc' is both
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
  astc12x12UnormSrgb;

  static GPUTextureFormat fromString(String s) {
    switch (s) {
      // 8-bit formats
      case 'r8unorm':
        return GPUTextureFormat.r8unorm;
      case 'r8snorm':
        return GPUTextureFormat.r8snorm;
      case 'r8uint':
        return GPUTextureFormat.r8uint;
      case 'r8sint':
        return GPUTextureFormat.r8sint;

      // 16-bit formats
      case 'r16uint':
        return GPUTextureFormat.r16uint;
      case 'r16sint':
        return GPUTextureFormat.r16sint;
      case 'r16float':
        return GPUTextureFormat.r16float;
      case 'rg8unorm':
        return GPUTextureFormat.rg8unorm;
      case 'rg8snorm':
        return GPUTextureFormat.rg8snorm;
      case 'rg8uint':
        return GPUTextureFormat.rg8uint;
      case 'rg8sint':
        return GPUTextureFormat.rg8sint;

      // 32-bit formats
      case 'r32uint':
        return GPUTextureFormat.r32uint;
      case 'r32sint':
        return GPUTextureFormat.r32sint;
      case 'r32float':
        return GPUTextureFormat.r32float;
      case 'rg16uint':
        return GPUTextureFormat.rg16uint;
      case 'rg16sint':
        return GPUTextureFormat.rg16sint;
      case 'rg16float':
        return GPUTextureFormat.rg16float;
      case 'rgba8unorm':
        return GPUTextureFormat.rgba8unorm;
      case 'rgba8unorm-srgb':
        return GPUTextureFormat.rgba8unormSrgb;
      case 'rgba8snorm':
        return GPUTextureFormat.rgba8snorm;
      case 'rgba8uint':
        return GPUTextureFormat.rgba8uint;
      case 'rgba8sint':
        return GPUTextureFormat.rgba8sint;
      case 'bgra8unorm':
        return GPUTextureFormat.bgra8unorm;
      case 'bgra8unorm-srgb':
        return GPUTextureFormat.bgra8unormSrgb;
      // Packed 32-bit formats
      case 'rgb9e5ufloat':
        return GPUTextureFormat.rgb9e5ufloat;
      case 'rgb10a2unorm':
        return GPUTextureFormat.rgb10a2unorm;
      case 'rg11b10ufloat':
        return GPUTextureFormat.rg11b10ufloat;

      // 64-bit formats
      case 'rg32uint':
        return GPUTextureFormat.rg32uint;
      case 'rg32sint':
        return GPUTextureFormat.rg32sint;
      case 'rg32float':
        return GPUTextureFormat.rg32float;
      case 'rgba16uint':
        return GPUTextureFormat.rgba16uint;
      case 'rgba16sint':
        return GPUTextureFormat.rgba16sint;
      case 'rgba16float':
        return GPUTextureFormat.rgba16float;

      // 128-bit formats
      case 'rgba32uint':
        return GPUTextureFormat.rgba32uint;
      case 'rgba32sint':
        return GPUTextureFormat.rgba32sint;
      case 'rgba32float':
        return GPUTextureFormat.rgba32float;

      // Depth/stencil formats
      case 'stencil8':
        return GPUTextureFormat.stencil8;
      case 'depth16unorm':
        return GPUTextureFormat.depth16unorm;
      case 'depth24plus':
        return GPUTextureFormat.depth24plus;
      case 'depth24plus-stencil8':
        return GPUTextureFormat.depth24plusStencil8;
      case 'depth32float':
        return GPUTextureFormat.depth32float;

      // 'depth32float-stencil8' feature
      case 'depth32float-stencil8':
        return GPUTextureFormat.depth32floatStencil8;

      // BC compressed formats usable if 'texture-compression-bc' is both
      // supported by the device/user agent and enabled in requestDevice.
      case 'bc1-rgba-unorm':
        return GPUTextureFormat.bc1RgbaUnorm;
      case 'bc1-rgba-unorm-srgb':
        return GPUTextureFormat.bc1RgbaUnormSrgb;
      case 'bc2-rgba-unorm':
        return GPUTextureFormat.bc2RgbaUnorm;
      case 'bc2-rgba-unorm-srgb':
        return GPUTextureFormat.bc2RgbaUnormSrgb;
      case 'bc3-rgba-unorm':
        return GPUTextureFormat.bc3RgbaUnorm;
      case 'bc3-rgba-unorm-srgb':
        return GPUTextureFormat.bc3RgbaUnormSrgb;
      case 'bc4-r-unorm':
        return GPUTextureFormat.bc4RUnorm;
      case 'bc4-r-snorm':
        return GPUTextureFormat.bc4RSnorm;
      case 'bc5-rg-unorm':
        return GPUTextureFormat.bc5RgUnorm;
      case 'bc5-rg-snorm':
        return GPUTextureFormat.bc5RgSnorm;
      case 'bc6h-rgb-ufloat':
        return GPUTextureFormat.bc6hRgbUfloat;
      case 'bc6h-rgb-float':
        return GPUTextureFormat.bc6hRgbFloat;
      case 'bc7-rgba-unorm':
        return GPUTextureFormat.bc7RgbaUnorm;
      case 'bc7-rgba-unorm-srgb':
        return GPUTextureFormat.bc7RgbaUnormSrgb;

      // ETC2 compressed formats usable if 'texture-compression-etc2' is both
      // supported by the device/user agent and enabled in requestDevice.
      case 'etc2-rgb8unorm':
        return GPUTextureFormat.etc2Rgb8unorm;
      case 'etc2-rgb8unorm-srgb':
        return GPUTextureFormat.etc2Rgb8unormSrgb;
      case 'etc2-rgb8a1unorm':
        return GPUTextureFormat.etc2Rgb8a1unorm;
      case 'etc2-rgb8a1unorm-srgb':
        return GPUTextureFormat.etc2Rgb8a1unormSrgb;
      case 'etc2-rgba8unorm':
        return GPUTextureFormat.etc2Rgba8unorm;
      case 'etc2-rgba8unorm-srgb':
        return GPUTextureFormat.etc2Rgba8unormSrgb;
      case 'eac-r11unorm':
        return GPUTextureFormat.eacR11unorm;
      case 'eac-r11snorm':
        return GPUTextureFormat.eacR11snorm;
      case 'eac-rg11unorm':
        return GPUTextureFormat.eacRg11unorm;
      case 'eac-rg11snorm':
        return GPUTextureFormat.eacRg11snorm;

      // ASTC compressed formats usable if 'texture-compression-astc' is both
      // supported by the device/user agent and enabled in requestDevice.
      case 'astc-4x4-unorm':
        return GPUTextureFormat.astc4x4Unorm;
      case 'astc-4x4-unorm-srgb':
        return GPUTextureFormat.astc4x4UnormSrgb;
      case 'astc-5x4-unorm':
        return GPUTextureFormat.astc5x4Unorm;
      case 'astc-5x4-unorm-srgb':
        return GPUTextureFormat.astc5x4UnormSrgb;
      case 'astc-5x5-unorm':
        return GPUTextureFormat.astc5x5Unorm;
      case 'astc-5x5-unorm-srgb':
        return GPUTextureFormat.astc5x5UnormSrgb;
      case 'astc-6x5-unorm':
        return GPUTextureFormat.astc6x5Unorm;
      case 'astc-6x5-unorm-srgb':
        return GPUTextureFormat.astc6x5UnormSrgb;
      case 'astc-6x6-unorm':
        return GPUTextureFormat.astc6x6Unorm;
      case 'astc-6x6-unorm-srgb':
        return GPUTextureFormat.astc6x6UnormSrgb;
      case 'astc-8x5-unorm':
        return GPUTextureFormat.astc8x5Unorm;
      case 'astc-8x5-unorm-srgb':
        return GPUTextureFormat.astc8x5UnormSrgb;
      case 'astc-8x6-unorm':
        return GPUTextureFormat.astc8x6Unorm;
      case 'astc-8x6-unorm-srgb':
        return GPUTextureFormat.astc8x6UnormSrgb;
      case 'astc-8x8-unorm':
        return GPUTextureFormat.astc8x8Unorm;
      case 'astc-8x8-unorm-srgb':
        return GPUTextureFormat.astc8x8UnormSrgb;
      case 'astc-10x5-unorm':
        return GPUTextureFormat.astc10x5Unorm;
      case 'astc-10x5-unorm-srgb':
        return GPUTextureFormat.astc10x5UnormSrgb;
      case 'astc-10x6-unorm':
        return GPUTextureFormat.astc10x6Unorm;
      case 'astc-10x6-unorm-srgb':
        return GPUTextureFormat.astc10x6UnormSrgb;
      case 'astc-10x8-unorm':
        return GPUTextureFormat.astc10x8Unorm;
      case 'astc-10x8-unorm-srgb':
        return GPUTextureFormat.astc10x8UnormSrgb;
      case 'astc-10x10-unorm':
        return GPUTextureFormat.astc10x10Unorm;
      case 'astc-10x10-unorm-srgb':
        return GPUTextureFormat.astc10x10UnormSrgb;
      case 'astc-12x10-unorm':
        return GPUTextureFormat.astc12x10Unorm;
      case 'astc-12x10-unorm-srgb':
        return GPUTextureFormat.astc12x10UnormSrgb;
      case 'astc-12x12-unorm':
        return GPUTextureFormat.astc12x12Unorm;
      case 'astc-12x12-unorm-srgb':
        return GPUTextureFormat.astc12x12UnormSrgb;
    }
    throw Exception('Invalid value for GPUTextureFormat');
  }

  int get nativeIndex => index + 1;
}
