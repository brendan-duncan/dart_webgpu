import '_map_util.dart';

class GPUImageDataLayout {
  final int offset;
  final int bytesPerRow;
  final int rowsPerImage;

  const GPUImageDataLayout(
      {this.offset = 0, required this.bytesPerRow, required this.rowsPerImage});

  factory GPUImageDataLayout.fromMap(Map<String, Object> map) {
    final offset = mapValue<int>(map['offset'], 0);
    final bytesPerRow = mapValueRequired<int>(map['bytesPerRow']);
    final rowsPerImage = mapValueRequired<int>(map['rowsPerImage']);
    return GPUImageDataLayout(
        offset: offset, bytesPerRow: bytesPerRow, rowsPerImage: rowsPerImage);
  }
}
