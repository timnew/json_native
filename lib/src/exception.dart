/// Json decoding exception
class JsonTypeException implements Exception {
  /// Error message
  final String message;

  JsonTypeException(this.message);

  @override
  String toString() => 'JsonTypeException: $message';
}
