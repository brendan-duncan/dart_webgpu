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
}
