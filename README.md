# json_native

[![Star this Repo](https://img.shields.io/github/stars/timnew/json_native.svg?style=flat-square)](https://github.com/timnew/json_native)
[![Pub Package](https://img.shields.io/pub/v/json_native.svg?style=flat-square)](https://pub.dev/packages/json_native)
[![Build Status](https://img.shields.io/github/workflow/status/timnew/json_native/test)](https://github.com/timnew/stated_result/actions?query=workflow%3Atest)

To consume json data, `json_serialisation` isn't always the most handy option.
Maybe because the JSON structure isn't clear, or json structure is dynamic, or we simply don't want to create so many classes just to read a few values.

In these situation, we will need to handle the raw output from `jsonDecode`.
It is a straightforward process, but not always as easy as it sounds.

## Problem with `jsonDecode`

Given having a JSON string as

```json
{
  "int": 1,
  "string": "string",
  "double": 1.1,
  "bool": true,
  "intList": [1, 2, 3],
  "stringList": ["a", "b", "c"],
  "mixedList": ["a", 1, false],
  "obj": { "key": "value" },
  "foo": { "bar": { "baz": true, "string": "string" } },
  "mixed": [{ "object": { "key": "value" } }]
}
```

To parse the JSON in dart, can consume the values in it, we will have code like this:

```dart
final root = jsonDecode(jsonString) as Map<String, dynamic>;

final intValue = root['int'] as int;
final strValue = root['string'] as String?;
final doubleValue = root['double'] as double;
final intList = (root['intList'] as List).cast();
final stringList = (root['stringList'] as List).cast();
final mixedList = root['mixedList'] as List;
final obj = root['obj'] as Map<String, dynamic>;
final baz = root['foo']['bar']['baz'] as bool;
final value = root['mixed'][0]['object']['key'] as String;
```

It is working but code is hard to read, is error-prone, is fragile to optional field, and hard to debug if thing goes wrong.

## With `json_native`

`Json Native` as its name suggested, is a solution designed to make this process easier.

```dart
import 'package:json_native/json_native.dart';

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
```
