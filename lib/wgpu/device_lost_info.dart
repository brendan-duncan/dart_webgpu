enum DeviceLostReason {
  unknown,
  destroyed
}

class DeviceLostInfo {
  final DeviceLostReason? reason;
  final String message;
  DeviceLostInfo(this.message, this.reason);
}
