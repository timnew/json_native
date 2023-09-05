import 'contract.dart';
import 'exception.dart';

bool isSameType<T1, T2>() => T1 == T2;
bool isSameOrNullableType<T1, T2>() => isSameType<T1, T2>() || isSameType<T1, T2?>();

T castJsonType<T>(String key, dynamic value) {
  assert(
    isSameType<T, dynamic>() || // Required if T isn't given
        isSameOrNullableType<T, String>() ||
        isSameOrNullableType<T, JsonObject>() ||
        isSameOrNullableType<T, bool>() ||
        isSameOrNullableType<T, int>() ||
        isSameOrNullableType<T, double>() ||
        isSameOrNullableType<T, List>(),
    'Type $T is not supported',
  );

  if (value is! T) {
    throw JsonTypeException("Key '$key' is not of type $T: $value");
  }

  return value;
}

String nestedKeyName(Iterable keys, [int? index]) =>
    index == null ? keys.join('.') : keys.take(index + 1).join('.');

dynamic digJsonTree<T>(dynamic current, List keys, int index) {
  final lastIndex = keys.length - 1;

  if (index > lastIndex) {
    return current;
  }

  final currentKey = keys[index];

  if (current is JsonObject) {
    if (currentKey is String) {
      return digJsonTree(current[currentKey], keys, index + 1);
    }
    throw JsonTypeException(
      'Expect ${nestedKeyName(keys, index)} as a String',
    );
  } else if (current is List) {
    if (currentKey is int) {
      return digJsonTree(current[currentKey], keys, index + 1);
    }
    throw JsonTypeException(
      'Expect ${nestedKeyName(keys, index)} as a String',
    );
  } else {
    throw JsonTypeException(
      'Dig failed on $current at "${nestedKeyName(keys, index)}", which is not JsonObject or List',
    );
  }
}
