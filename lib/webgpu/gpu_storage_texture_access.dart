/// Indicates whether texture views bound to this binding will be bound for
/// readOnly or writeOnly access.
enum GPUStorageTextureAccess {
  writeOnly;

  static GPUStorageTextureAccess fromString(String s) {
    switch (s) {
      case 'write-only':
        return GPUStorageTextureAccess.writeOnly;
    }
    throw Exception('Invalid value for GPUStorageTextureAccess');
  }

  int get nativeIndex => index + 1;
}
