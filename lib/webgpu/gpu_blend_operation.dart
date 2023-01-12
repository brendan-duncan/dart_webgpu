/// Defines the algorithm used to combine source and destination blend factors
enum GpuBlendOperation {
  disabled,
  add,
  subtract,
  reverseSubtract,
  min,
  max;

  int get nativeIndex => index;
}
