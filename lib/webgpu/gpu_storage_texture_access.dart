/// Indicates whether texture views bound to this binding will be bound for
/// readOnly or writeOnly access.
enum GpuStorageTextureAccess {
  writeOnly;

  int get nativeIndex => index + 1;
}
