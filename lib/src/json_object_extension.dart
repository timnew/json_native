import 'exception.dart';
import 'internal_helpers.dart';
import 'contract.dart';

extension JsonObjectExtension on JsonObject {
  T get<T>(String key) => castJsonType(key, this[key]);
  T? tryGet<T>(String key) {
    try {
      return get<T>(key);
    } on JsonTypeException {
      return null;
    }
  }

  JsonObject getObj(String key) => get<JsonObject>(key);
  JsonObject? tryGetObj(String key) => get<JsonObject?>(key);

  List<T> getList<T>(String key) => get<List>(key).cast();
  List<T>? tryGetList<T>(String key) => get<List?>(key)?.cast();

  T dig<T>(List keys) {
    if (keys.isEmpty) {
      throw JsonTypeException('No keys provided');
    }

    return castJsonType(nestedKeyName(keys), digJsonTree(this, keys, 0));
  }

  T? tryDig<T>(List keys) {
    try {
      return dig<T>(keys);
    } on JsonTypeException {
      return null;
    }
  }
}
