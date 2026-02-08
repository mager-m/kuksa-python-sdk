////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025 Eclipse KUKSA
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0
////////////////////////////////////////////////////////////////////////

import 'package:test/test.dart';
import 'package:kuksa_client_dart/kuksa_client_dart.dart';

void main() {
  group('ValueRestriction', () {
    test('creates restriction with min and max', () {
      final restriction = ValueRestriction(min: 0, max: 100);

      expect(restriction.min, equals(0));
      expect(restriction.max, equals(100));
      expect(restriction.allowedValues, isNull);
    });

    test('creates restriction with allowed values', () {
      final restriction = ValueRestriction(
        allowedValues: ['red', 'green', 'blue'],
      );

      expect(restriction.allowedValues, equals(['red', 'green', 'blue']));
      expect(restriction.min, isNull);
      expect(restriction.max, isNull);
    });

    test('toString works correctly', () {
      final restriction = ValueRestriction(min: 0, max: 100);
      final str = restriction.toString();

      expect(str, contains('min: 0'));
      expect(str, contains('max: 100'));
    });
  });

  group('Metadata', () {
    test('creates metadata with all fields', () {
      final restriction = ValueRestriction(min: 0, max: 200);
      final metadata = Metadata(
        dataType: DataType.float,
        entryType: EntryType.sensor,
        description: 'Vehicle speed',
        comment: 'In km/h',
        unit: 'km/h',
        valueRestriction: restriction,
      );

      expect(metadata.dataType, equals(DataType.float));
      expect(metadata.entryType, equals(EntryType.sensor));
      expect(metadata.description, equals('Vehicle speed'));
      expect(metadata.comment, equals('In km/h'));
      expect(metadata.unit, equals('km/h'));
      expect(metadata.valueRestriction, equals(restriction));
    });

    test('creates metadata with minimal fields', () {
      final metadata = Metadata(dataType: DataType.boolean);

      expect(metadata.dataType, equals(DataType.boolean));
      expect(metadata.entryType, isNull);
      expect(metadata.description, isNull);
    });

    test('toString works correctly', () {
      final metadata = Metadata(
        dataType: DataType.int32,
        entryType: EntryType.actuator,
        description: 'Test',
        unit: 'meters',
      );
      final str = metadata.toString();

      expect(str, contains('DataType.int32'));
      expect(str, contains('EntryType.actuator'));
    });

    test('equality works correctly', () {
      final m1 = Metadata(
        dataType: DataType.float,
        description: 'Speed',
        unit: 'km/h',
      );
      final m2 = Metadata(
        dataType: DataType.float,
        description: 'Speed',
        unit: 'km/h',
      );
      final m3 = Metadata(
        dataType: DataType.double,
        description: 'Speed',
        unit: 'km/h',
      );

      expect(m1, equals(m2));
      expect(m1, isNot(equals(m3)));
    });
  });
}
