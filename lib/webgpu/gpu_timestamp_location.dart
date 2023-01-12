enum GPUTimestampLocation {
  beginning,
  end;

  static GPUTimestampLocation fromString(String s) {
    switch (s) {
      case 'beginning':
        return GPUTimestampLocation.beginning;
      case 'end':
        return GPUTimestampLocation.end;
    }
    throw Exception('Invalid value for GPUTimestampLocation');
  }

  int get nativeIndex => index;
}
