/// Indicates whether texture views bound to this binding will be bound for
/// readOnly or writeOnly access.
enum StorageTextureAccess {
  writeOnly;

  int get nativeIndex => index + 1;
}
