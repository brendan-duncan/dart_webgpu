class Extent3D {
  int width;
  int height;
  int depthOrArrayLayer;

  Extent3D(this.width, this.height, [this.depthOrArrayLayer = 1]);
}
