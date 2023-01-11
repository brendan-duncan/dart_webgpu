T getMapValue<T>(Map<String, Object> map, String key, T defaultValue) {
  if (!map.containsKey(key)) {
    return defaultValue;
  }
  if (map[key] is! T) {
    throw Exception('Invalid data');
  }
  return map[key] as T;
}

T getMapValueRequired<T>(Map<String, Object> map, String key) {
  if (!map.containsKey(key)) {
    throw Exception('Invalid data');
  }
  if (map[key] is! T) {
    throw Exception('Invalid data');
  }
  return map[key] as T;
}
