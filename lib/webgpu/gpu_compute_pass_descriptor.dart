import '_map_util.dart';
import 'gpu_timestamp_write.dart';

class GPUComputePassDescriptor {
  /// A sequence of [GPUTimestampWrite] values defines where and when
  /// timestamp values will be written for this pass.
  final List<GPUTimestampWrite>? timestampWrites;

  const GPUComputePassDescriptor({this.timestampWrites});

  factory GPUComputePassDescriptor.fromMap(Map<String, Object> map) {
    final timestampWrites =
        mapListNullable<GPUTimestampWrite>(map['timestampWrites']);

    return GPUComputePassDescriptor(timestampWrites: timestampWrites);
  }
}
