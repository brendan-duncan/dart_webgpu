import 'power_preference.dart';

class AdapterOptions {
  PowerPreference powerPreference;
  bool forceFallbackAdapter;

  AdapterOptions(
      {this.powerPreference = PowerPreference.highPerformance,
      this.forceFallbackAdapter = false});
}
