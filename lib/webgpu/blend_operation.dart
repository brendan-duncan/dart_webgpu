/// Defines the algorithm used to combine source and destination blend factors
enum BlendOperation {
  add,
  subtract,
  reverseSubtract,
  min,
  max;

  int get nativeIndex => index + 1;
}
