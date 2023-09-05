import 'dart:convert';

export 'dart:convert' show jsonDecode, jsonEncode;

/// Same as [jsonDecode] but returns strong typed result.
T jsonDecodeCast<T>(String json) => jsonDecode(json) as T;

/// Same as [jsonDecode] but returns strong typed list.
List<T> jsonDecodeList<T>(String json) => jsonDecodeCast<List>(json).cast<T>();
