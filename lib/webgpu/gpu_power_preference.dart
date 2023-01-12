enum GPUPowerPreference {
  lowPower,
  highPerformance;

  static GPUPowerPreference fromString(String s) {
    switch (s) {
      case 'low-power':
        return GPUPowerPreference.lowPower;
      case 'high-performance':
        return GPUPowerPreference.highPerformance;
    }
    throw Exception('Invalid value for GPUPowerPreference');
  }

  int get nativeIndex => index + 1;
}
