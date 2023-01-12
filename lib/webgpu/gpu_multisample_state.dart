import '_map_util.dart';

class GpuMultisampleState {
  final int count;
  final int mask;
  final bool alphaToCoverageEnabled;

  const GpuMultisampleState(
      {this.count = 1,
      this.mask = 0xffffffff,
      this.alphaToCoverageEnabled = false});

  factory GpuMultisampleState.fromMap(Map<String, Object> map) {
    final count = getMapValue<int>(map['count'], 1);
    final mask = getMapValue<int>(map['mask'], 0xffffffff);
    final a = getMapValue<bool>(map['alphaToCoverageEnabled'], false);
    return GpuMultisampleState(
        count: count, mask: mask, alphaToCoverageEnabled: a);
  }
}
