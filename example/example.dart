import 'package:json_native/json_native.dart';

const jsonString = """
 {
  "int": 1,
  "string": "string",
  "double": 1.1,
  "bool": true,
  "intList": [1, 2, 3],
  "stringList": ["a", "b", "c"],
  "obj": { "key": "value" },
  "foo": { "bar": { "baz": true, "string": "string" } },
  "mixed": [{ "object": { "key": "value" } }]
}
""";
void main() {
  vanilla();
  withJsonNative();
}

void vanilla() {
  final root = jsonDecode(jsonString) as Map<String, dynamic>;

  final intValue = root['int'] as int;
  final strValue = root['string'] as String;
  final doubleValue = root['double'] as double;
  final intList = (root['intList'] as List).cast();
  final stringList = (root['stringList'] as List).cast();
  final obj = root['obj'] as Map<String, dynamic>;
  final baz = root['foo']['bar']['baz'] as bool;
  final value = root['mixed'][0]['object']['key'] as String;
}

void withJsonNative() {
  final JsonObject root = jsonDecodeCast(jsonString);

  // Yes, JsonObject isn't a new type but an type alias!
  print(root.runtimeType == Map<String, dynamic>);

  // get would cast the type for you
  final intValue = root.get<int>('int');

  // Yes, nullable type is also supported
  final strValue = root.get<String?>('string');

  // Type inference would figure out the generic param
  final double doubleValue = root.get('double');

  // Get a strong typed list
  final intList = root.getList<int>('intList');

  // Again, type inference would save the generic parameter.
  final List<String> stringList = root.getList('stringList');

  // If generic parameter is not given, it falls back to dynamic, which can be omitted.
  final mixedList = root.getList('mixedList');

  // getObj returns JsonObject.
  final obj = root.getObj('obj');

  // You can nested a series of get into a dig.
  final baz = root.dig<bool>(['foo', 'bar', 'baz']);

  // dig also support mixed of list and object
  final value = root.dig<String>(['mixed', 0, 'object', 'key']);
}
