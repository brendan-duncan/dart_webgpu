import '_map_util.dart';
import 'timestamp_write.dart';

class ComputePassDescriptor {
  /// A sequence of [TimestampWrite] values defines where and when
  /// timestamp values will be written for this pass.
  final List<TimestampWrite>? timestampWrites;

  const ComputePassDescriptor({this.timestampWrites});

  factory ComputePassDescriptor.fromMap(Map<String, Object> map) {
    final timestampWrites =
        getMapListNullable<TimestampWrite>(map['timestampWrites']);

    return ComputePassDescriptor(timestampWrites: timestampWrites);
  }
}
