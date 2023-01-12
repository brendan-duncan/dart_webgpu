/// The index format determines both the data type of index values in a buffer
/// and, when used with strip primitive topologies (lineStrip or triangleStrip)
/// also specifies the primitive restart value.
enum GPUIndexFormat {
  undefined,
  uint16,
  uint32;

  static GPUIndexFormat fromString(String s) {
    switch (s) {
      case 'undefined':
        return GPUIndexFormat.undefined;
      case 'uint16':
        return GPUIndexFormat.uint16;
      case 'uint32':
        return GPUIndexFormat.uint32;
    }
    throw Exception('Invalid value for GPUIndexFormat');
  }

  int get nativeIndex => index;
}
