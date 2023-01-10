class ImageDataLayout {
  final int offset;
  final int bytesPerRow;
  final int rowsPerImage;
  const ImageDataLayout({this.offset = 0, required this.bytesPerRow,
    required this.rowsPerImage});
}
