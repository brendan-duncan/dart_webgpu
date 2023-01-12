enum GpuPowerPreference {
  lowPower,
  highPerformance;

  int get nativeIndex => index + 1;
}
