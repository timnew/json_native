class JsonTypeException implements Exception {
  final String message;

  JsonTypeException(this.message);

  @override
  String toString() => 'JsonTypeException: $message';
}
