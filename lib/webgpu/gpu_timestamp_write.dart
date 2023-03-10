import '_map_util.dart';
import 'gpu_query_set.dart';
import 'gpu_timestamp_location.dart';

class GPUTimestampWrite {
  final GPUQuerySet querySet;
  final int queryIndex;
  final GPUTimestampLocation location;

  const GPUTimestampWrite(
      {required this.querySet,
      required this.queryIndex,
      required this.location});

  factory GPUTimestampWrite.fromMap(Map<String, Object> map) {
    final querySet = mapValueRequired<GPUQuerySet>(map['querySet']);
    final queryIndex = mapValueRequired<int>(map['queryIndex']);
    final location = mapValueRequired<GPUTimestampLocation>(map['location']);
    return GPUTimestampWrite(
        querySet: querySet, queryIndex: queryIndex, location: location);
  }
}
