/// defines how either a source or destination blend factors is calculated
enum GPUBlendFactor {
  zero,
  one,
  src,
  oneMinusSrc,
  srcAlpha,
  oneMinusSrcAlpha,
  dst,
  oneMinusDst,
  dstAlpha,
  oneMinusDstAlpha,
  srcAlphaSaturated,
  constant,
  oneMinusConstant;

  static GPUBlendFactor fromString(String s) {
    switch (s) {
      case 'zero':
        return GPUBlendFactor.zero;
      case 'one':
        return GPUBlendFactor.one;
      case 'src':
        return GPUBlendFactor.src;
      case 'one-minus-src':
        return GPUBlendFactor.oneMinusSrc;
      case 'src-alpha':
        return GPUBlendFactor.srcAlpha;
      case 'one-minus-src-alpha':
        return GPUBlendFactor.oneMinusSrcAlpha;
      case 'dst':
        return GPUBlendFactor.dst;
      case 'one-minus-dst':
        return GPUBlendFactor.oneMinusDst;
      case 'dst-alpha':
        return GPUBlendFactor.dstAlpha;
      case 'one-minus-dst-alpha':
        return GPUBlendFactor.oneMinusDstAlpha;
      case 'src-alpha-saturated':
        return GPUBlendFactor.srcAlphaSaturated;
      case 'constant':
        return GPUBlendFactor.constant;
      case 'one-minus-constant':
        return GPUBlendFactor.oneMinusConstant;
    }
    throw Exception('Invalid value for GPUBlendFactor');
  }

  int get nativeIndex => index + 1;
}
