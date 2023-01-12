/// Specifies the behavior of a comparison sampler. If a comparison sampler is
/// used in a shader, an input value is compared to the sampled texture value,
/// and the result of this comparison test (0.0f for pass, or 1.0f for fail) is
/// used in the filtering operation.
enum GPUCompareFunction {
  /// Not a comparison sampler.
  undefined,

  /// Comparison tests never pass.
  never,

  /// A provided value passes the comparison test if it is less than the sampled
  /// value.
  less,

  /// A provided value passes the comparison test if it is equal to the sampled
  /// value.
  equal,

  /// A provided value passes the comparison test if it is less than or equal to
  /// the sampled value.
  lessEqual,

  /// A provided value passes the comparison test if it is greater than the
  /// sampled value.
  greater,

  /// A provided value passes the comparison test if it is not equal to the
  /// sampled value.
  notEqual,

  /// A provided value passes the comparison test if it is greater than or equal
  /// to the sampled value.
  greaterEqual,

  /// Comparison tests always pass.
  always;

  static GPUCompareFunction fromString(String s) {
    switch (s) {
      case "never":
        return GPUCompareFunction.never;
      case "less":
        return GPUCompareFunction.less;
      case "equal":
        return GPUCompareFunction.equal;
      case "less-equal":
        return GPUCompareFunction.lessEqual;
      case "greater":
        return GPUCompareFunction.greater;
      case "not-equal":
        return GPUCompareFunction.notEqual;
      case "greater-equal":
        return GPUCompareFunction.greaterEqual;
      case "always":
        return GPUCompareFunction.always;
    }
    throw Exception('Invalid value for GPUCompareFunction');
  }

  int get nativeIndex => index;
}
