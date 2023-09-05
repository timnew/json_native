# json_native

[![Star this Repo](https://img.shields.io/github/stars/timnew/json_native)](https://github.com/timnew/json_native)
[![Pub Package](https://img.shields.io/pub/v/json_native)](https://pub.dev/packages/json_native)
[![Build Status](https://img.shields.io/github/actions/workflow/status/timnew/json_native/test.yml)](https://github.com/timnew/json_native/actions/workflows/test.yml)

## Overview

Need to work with JSON in Dart? `json_serializable`` might not always be your best bet, especially when:

- The JSON structure is unclear or dynamic.
- You only need to extract a few values, making it overkill to create a full data model.
- You're dealing with complex types that json_serializable can't handle, like union types.

In such cases, you might revert to raw `jsonDecode``, but that comes with its own set of challenges.

## The Problem: using `jsonDecode`

Consider the following JSON string:

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

Parsing this JSON in Dart usually involves code like:

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

This approach is functional but has several drawbacks:

- Code readability suffers.
- It's error-prone.
- Handling optional fields is tricky.
- Debugging can be challenging.

## The Solution: Using `json_native`

`json_native` aims to simplify this process with more readable and less error-prone code.

Here's how:

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

**Features:**

- Type casting is automatically handled.
- Supports nullable types.
- Type inference eliminates the need for explicit generic parameters.
- Provides strongly-typed lists.
- Allows for nested object and list traversal with dig.
