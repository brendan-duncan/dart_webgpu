class MultisampleState {
  final int count;
  final int mask;
  final bool alphaToCoverageEnabled;

  const MultisampleState(
      {this.count = 1,
      this.mask = 0xffffffff,
      this.alphaToCoverageEnabled = false});

  factory MultisampleState.fromMap(Map<String, Object> map) {
    final count = map['count'] is int ? map['count'] as int : 1;
    final mask = map['mask'] is int ? map['mask'] as int : 0xffffffff;
    final a = map['alphaToCoverageEnabled'] as bool? ?? false;
    return MultisampleState(
        count: count, mask: mask, alphaToCoverageEnabled: a);
  }
}
