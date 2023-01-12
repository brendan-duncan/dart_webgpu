/// Defines the algorithm used to combine source and destination blend factors
enum GPUBlendOperation {
  disabled,
  add,
  subtract,
  reverseSubtract,
  min,
  max;

  static GPUBlendOperation fromString(String s) {
    switch (s) {
      case "add":
        return GPUBlendOperation.add;
      case "subtract":
        return GPUBlendOperation.subtract;
      case "reverse-subtract":
        return GPUBlendOperation.reverseSubtract;
      case "min":
        return GPUBlendOperation.min;
      case "max":
        return GPUBlendOperation.max;
    }
    throw Exception('Invalid value for GPUBlendOperation');
  }

  int get nativeIndex => index;
}
