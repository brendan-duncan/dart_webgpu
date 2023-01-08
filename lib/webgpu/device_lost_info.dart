enum DeviceLostReason { unknown, destroyed }

class DeviceLostInfo {
  final DeviceLostReason? reason;
  final String message;
  const DeviceLostInfo(this.message, this.reason);
}
