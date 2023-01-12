enum GPUDeviceLostReason {
  unknown,
  destroyed;

  static GPUDeviceLostReason fromString(String s) {
    switch (s) {
      case "unknown":
        return GPUDeviceLostReason.unknown;
      case "destroyed":
        return GPUDeviceLostReason.destroyed;
    }
    throw Exception('Invalid value for GPUDeviceLostReason');
  }

  int get nativeIndex => index;
}
