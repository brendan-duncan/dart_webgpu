import '_map_util.dart';
import 'gpu_query_set.dart';
import 'gpu_timestamp_location.dart';

class GpuTimestampWrite {
  final GpuQuerySet querySet;
  final int queryIndex;
  final GpuTimestampLocation location;

  const GpuTimestampWrite(
      {required this.querySet,
      required this.queryIndex,
      required this.location});

  factory GpuTimestampWrite.fromMap(Map<String, Object> map) {
    final querySet = getMapValueRequired<GpuQuerySet>(map['querySet']);
    final queryIndex = getMapValueRequired<int>(map['queryIndex']);
    final location = getMapValueRequired<GpuTimestampLocation>(map['location']);
    return GpuTimestampWrite(
        querySet: querySet, queryIndex: queryIndex, location: location);
  }
}
