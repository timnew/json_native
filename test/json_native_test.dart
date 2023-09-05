import 'package:test/test.dart';
import 'package:json_native/json_native.dart';

void main() {
  final throwsJsonTypeException = throwsA(isA<JsonTypeException>());
  final throwsAssertionError = throwsA(isA<AssertionError>());

  group('json_native', () {
    const JsonObject testObject = {
      'int': 1,
      'string': 'string',
      'double': 1.1,
      'bool': true,
      'intList': <dynamic>[1, 2, 3],
      'stringList': <dynamic>['a', 'b', 'c'],
      'obj': <String, dynamic>{
        'key': 'value',
      },
      'foo': <String, dynamic>{
        'bar': <String, dynamic>{
          'baz': true,
          'string': 'string',
        },
      },
      'mixed': [
        <String, dynamic>{
          'object': <String, dynamic>{
            'key': 'value',
          },
        },
      ],
    };

    group('get', () {
      group('nullable', () {
        test('int?', () {
          expect(testObject.get<int?>('int'), 1);
          expect(testObject.get<int?>('not_exist'), null);
        });

        test('String?', () {
          expect(testObject.get<String?>('string'), 'string');
          expect(testObject.get<String?>('not_exist'), null);
        });

        test('double?', () {
          expect(testObject.get<double?>('double'), 1.1);
          expect(testObject.get<double?>('not_exist'), null);
        });

        test('bool?', () {
          expect(testObject.get<bool?>('bool'), true);
          expect(testObject.get<bool?>('not_exist'), null);
        });

        test('List?', () {
          expect(testObject.get<List?>('intList'), [1, 2, 3]);
          expect(testObject.get<List?>('not_exist'), null);
        });

        test('JsonObject?', () {
          expect(testObject.get<JsonObject?>('obj'), {'key': 'value'});
          expect(testObject.get<JsonObject?>('not_exist'), null);
        });

        test('unsupported nullable type', () {
          expect(
            () => testObject.get<DateTime?>('dateType'),
            throwsAssertionError,
          );
        });

        test('wrong nullable type', () {
          expect(
            () => testObject.get<String?>('int'),
            throwsJsonTypeException,
          );
        });
      });

      group('not nullable', () {
        test('int', () {
          expect(testObject.get<int>('int'), 1);
          expect(
            () => testObject.get<int>('not_exist'),
            throwsJsonTypeException,
          );
        });

        test('String', () {
          expect(testObject.get<String>('string'), 'string');
          expect(
            () => testObject.get<String>('not_exist'),
            throwsJsonTypeException,
          );
        });

        test('double', () {
          expect(testObject.get<double>('double'), 1.1);
          expect(
            () => testObject.get<double>('not_exist'),
            throwsJsonTypeException,
          );
        });

        test('bool', () {
          expect(testObject.get<bool>('bool'), true);
          expect(
            () => testObject.get<bool>('not_exist'),
            throwsJsonTypeException,
          );
        });

        test('List', () {
          expect(testObject.get<List>('intList'), [1, 2, 3]);
          expect(
            testObject.get<List>('intList'),
            isA<List>(),
          );
          expect(
            () => testObject.get<List>('not_exist'),
            throwsJsonTypeException,
          );
        });

        test('JsonObject', () {
          expect(testObject.get<JsonObject>('obj'), {'key': 'value'});
          expect(
            () => testObject.get<JsonObject>('not_exist'),
            throwsJsonTypeException,
          );
        });

        test('unsupported type', () {
          expect(
            () => testObject.get<DateTime>('dateType'),
            throwsAssertionError,
          );
        });
      });
    });

    test('getObj', () {
      expect(testObject.getObj('obj'), {'key': 'value'});
      expect(
        () => testObject.getObj('not_exist'),
        throwsJsonTypeException,
      );
    });

    test('tryGetObj', () {
      expect(testObject.tryGetObj('obj'), {'key': 'value'});
      expect(testObject.tryGetObj('not_exist'), null);
    });

    test('getList', () {
      expect(testObject.getList<int>('intList'), [1, 2, 3]);
      expect(testObject.getList<int>('intList'), isA<List<int>>());
      expect(
        () => testObject.getList('not_exist'),
        throwsJsonTypeException,
      );
    });

    test('tryGetList', () {
      expect(testObject.tryGetList<int>('intList'), [1, 2, 3]);
      expect(testObject.tryGetList<int>('intList'), isA<List<int>>());
      expect(testObject.tryGetList('not_exist'), null);
    });

    group('tryDig', () {
      test('dig value', () {
        expect(testObject.tryDig<bool>(['foo', 'bar', 'baz']), true);
        expect(testObject.tryDig<String>(['foo', 'bar', 'string']), 'string');
      });

      test('mixed dig', () {
        expect(
          testObject.tryDig<String>(['mixed', 0, 'object', 'key']),
          'value',
        );
      });

      test('field not exist', () {
        expect(
          testObject.tryDig<String>(['foo', 'bar', 'not_exist']),
          null,
        );
      });

      test('parent not exist', () {
        expect(
          testObject.tryDig<String>([
            'foo',
            'not_exist',
            'baz',
          ]),
          null,
        );
      });

      test('parent is not object', () {
        expect(
          testObject.tryDig<String>(['string', 'foo', 'bar', 'baz']),
          null,
        );
      });
    });

    group('dig', () {
      test('dig value', () {
        expect(testObject.dig<bool>(['foo', 'bar', 'baz']), true);
        expect(
          testObject.dig<String>(['foo', 'bar', 'string']),
          'string',
        );
      });

      test('mixed dig', () {
        expect(
          testObject.dig<String>(['mixed', 0, 'object', 'key']),
          'value',
        );
      });

      test('field not exist', () {
        expect(
          () => testObject.dig<String>(['foo', 'bar', 'not_exist']),
          throwsJsonTypeException,
        );
      });

      test('parent not exist', () {
        expect(
          () => testObject.dig<String>(['foo', 'not_exist', 'baz']),
          throwsJsonTypeException,
        );
      });

      test('parent is not object', () {
        expect(
          () => testObject.dig<String>(['string', 'foo', 'bar', 'baz']),
          throwsJsonTypeException,
        );
      });
    });
  });
}
