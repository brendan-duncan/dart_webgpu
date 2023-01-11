import '_map_util.dart';
import 'query_set.dart';
import 'timestamp_location.dart';

class TimestampWrite {
  final QuerySet querySet;
  final int queryIndex;
  final TimestampLocation location;

  const TimestampWrite(
      {required this.querySet,
      required this.queryIndex,
      required this.location});

  factory TimestampWrite.fromMap(Map<String, Object> map) {
    final querySet = getMapValueRequired<QuerySet>(map['querySet']);
    final queryIndex = getMapValueRequired<int>(map['queryIndex']);
    final location = getMapValueRequired<TimestampLocation>(map['location']);
    return TimestampWrite(
        querySet: querySet, queryIndex: queryIndex, location: location);
  }
}
