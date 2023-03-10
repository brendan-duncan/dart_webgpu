import '_map_util.dart';
import 'gpu_buffer.dart';

class GPUImageCopyBuffer {
  /// The offset, in bytes, from the beginning of the image data source
  /// (such as a ImageCopyBuffer.buffer) to the start of the image data within
  /// that source.
  final int offset;

  /// The stride, in bytes, between the beginning of each block row and the
  /// subsequent block row.
  ///
  /// Required if there are multiple block rows (i.e. the copy height or depth
  /// is more than one block).
  final int bytesPerRow;

  /// Number of block rows per single image of the texture.
  /// rowsPerImage × bytesPerRow is the stride, in bytes, between the beginning
  /// of each image of data and the subsequent image.
  ///
  /// Required if there are multiple images (i.e. the copy depth is more than
  /// one).
  final int rowsPerImage;

  /// A buffer which either contains image data to be copied or will store the
  /// image data being copied, depending on the method it is being passed to.
  final GPUBuffer buffer;

  const GPUImageCopyBuffer(
      {this.offset = 0,
      this.bytesPerRow = 0,
      this.rowsPerImage = 0,
      required this.buffer});

  factory GPUImageCopyBuffer.fromMap(Map<String, Object> map) {
    final offset = mapValue<int>(map['offset'], 0);
    final bytesPerRow = mapValue<int>(map['bytesPerRow'], 0);
    final rowsPerImage = mapValue<int>(map['rowsPerImage'], 0);
    final buffer = mapValueRequired<GPUBuffer>(map['buffer']);

    return GPUImageCopyBuffer(
        buffer: buffer,
        offset: offset,
        bytesPerRow: bytesPerRow,
        rowsPerImage: rowsPerImage);
  }
}
