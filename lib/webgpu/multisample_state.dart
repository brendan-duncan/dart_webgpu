class MultisampleState {
  final int count;
  final int mask;
  final bool alphaToCoverageEnabled;

  const MultisampleState(
      {this.count = 1,
      this.mask = 0xffffffff,
      this.alphaToCoverageEnabled = false});
}
