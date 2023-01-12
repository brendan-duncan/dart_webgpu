import '_map_util.dart';

class GPUMultisampleState {
  final int count;
  final int mask;
  final bool alphaToCoverageEnabled;

  const GPUMultisampleState(
      {this.count = 1,
      this.mask = 0xffffffff,
      this.alphaToCoverageEnabled = false});

  factory GPUMultisampleState.fromMap(Map<String, Object> map) {
    final count = getMapValue<int>(map['count'], 1);
    final mask = getMapValue<int>(map['mask'], 0xffffffff);
    final a = getMapValue<bool>(map['alphaToCoverageEnabled'], false);
    return GPUMultisampleState(
        count: count, mask: mask, alphaToCoverageEnabled: a);
  }
}
