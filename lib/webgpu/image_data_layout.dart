import '_map_util.dart';

class ImageDataLayout {
  final int offset;
  final int bytesPerRow;
  final int rowsPerImage;

  const ImageDataLayout(
      {this.offset = 0, required this.bytesPerRow, required this.rowsPerImage});

  factory ImageDataLayout.fromMap(Map<String, Object> map) {
    final offset = getMapValue<int>(map['offset'], 0);
    final bytesPerRow = getMapValueRequired<int>(map['bytesPerRow']);
    final rowsPerImage = getMapValueRequired<int>(map['rowsPerImage']);
    return ImageDataLayout(
        offset: offset, bytesPerRow: bytesPerRow, rowsPerImage: rowsPerImage);
  }
}