import '_map_util.dart';
import 'gpu_timestamp_write.dart';

class GpuComputePassDescriptor {
  /// A sequence of [GpuTimestampWrite] values defines where and when
  /// timestamp values will be written for this pass.
  final List<GpuTimestampWrite>? timestampWrites;

  const GpuComputePassDescriptor({this.timestampWrites});

  factory GpuComputePassDescriptor.fromMap(Map<String, Object> map) {
    final timestampWrites =
        getMapListNullable<GpuTimestampWrite>(map['timestampWrites']);

    return GpuComputePassDescriptor(timestampWrites: timestampWrites);
  }
}
