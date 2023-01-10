/// The index format determines both the data type of index values in a buffer
/// and, when used with strip primitive topologies (lineStrip or triangleStrip)
/// also specifies the primitive restart value.
enum IndexFormat {
  undefined,
  uint16,
  uint32;

  int get nativeIndex => index;
}
