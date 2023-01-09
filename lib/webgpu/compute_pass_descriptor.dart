import 'timestamp_write.dart';

class ComputePassDescriptor {
  /// A sequence of [TimestampWrite] values defines where and when
  /// timestamp values will be written for this pass.
  final List<TimestampWrite>? timestampWrites;

  const ComputePassDescriptor({this.timestampWrites});
}
