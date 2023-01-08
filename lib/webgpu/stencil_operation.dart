enum StencilOperation {
  keep,
  zero,
  replace,
  invert,
  incrementClamp,
  decrementClamp,
  incrementWrap,
  decrementWrap;

  int get nativeIndex => index + 1;
}
