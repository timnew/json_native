import 'dart:convert';

export 'dart:convert' show jsonDecode, jsonEncode;

T jsonDecodeCast<T>(String json) => jsonDecode(json) as T;
