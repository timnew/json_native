import 'contract.dart';
import 'exception.dart';
import 'internal_helpers.dart';

/// Extension methods for [JsonObject]
extension JsonObjectExtension on JsonObject {
  /// Get value as [T] with given [key]
  T get<T>(String key) => castJsonType(key, this[key]);

  /// Try get value as [T] with given [key]. It returns `null` if failed.
  T? tryGet<T>(String key) {
    try {
      return get<T>(key);
    } on JsonTypeException {
      return null;
    }
  }

  /// Get child object with given [key]
  JsonObject getObj(String key) => get<JsonObject>(key);

  /// Try child object with given [key]. It returns `null` if failed.
  JsonObject? tryGetObj(String key) => get<JsonObject?>(key);

  /// Get child [List] with given [key]
  List<T> getList<T>(String key) => get<List>(key).cast();

  /// Try child [List] with given [key]. It returns `null` if failed.
  List<T>? tryGetList<T>(String key) => get<List?>(key)?.cast();

  /// Get child map with given [key]
  /// The difference between [getMap] and [getObj], is that [getMap] returns `Map<String, T>` instead of [JsonObject]
  Map<String, T> getMap<T>(String key) => get<JsonObject>(key).cast();

  /// Try child map with given [key]
  /// The difference between [getMap] and [getObj], is that [getMap] returns `Map<String, T>` instead of [JsonObject]
  Map<String, T>? tryGetMap<T>(String key) => get<JsonObject?>(key)?.cast();

  /// Get value across nested objects/list with given [keys]
  T dig<T>(List keys) {
    if (keys.isEmpty) {
      throw JsonTypeException('No keys provided');
    }

    return castJsonType(nestedKeyName(keys), digJsonTree(this, keys, 0));
  }

  /// Try get value across nested objects/list with given [keys]. It returns `null` if failed.
  T? tryDig<T>(List keys) {
    try {
      return dig<T>(keys);
    } on JsonTypeException {
      return null;
    }
  }
}
