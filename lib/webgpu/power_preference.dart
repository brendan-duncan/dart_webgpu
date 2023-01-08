enum PowerPreference {
  lowPower,
  highPerformance;

  int get nativeIndex => index + 1;
}
