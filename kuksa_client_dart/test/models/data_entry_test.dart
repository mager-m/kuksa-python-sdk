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
  group('DataEntry', () {
    test('creates data entry with all fields', () {
      final value = Datapoint(value: 120.5);
      final target = Datapoint(value: 130.0);
      final metadata = Metadata(
        dataType: DataType.float,
        unit: 'km/h',
      );

      final entry = DataEntry(
        path: 'Vehicle.Speed',
        value: value,
        actuatorTarget: target,
        metadata: metadata,
      );

      expect(entry.path, equals('Vehicle.Speed'));
      expect(entry.value, equals(value));
      expect(entry.actuatorTarget, equals(target));
      expect(entry.metadata, equals(metadata));
    });

    test('creates data entry with minimal fields', () {
      final entry = DataEntry(path: 'Vehicle.Speed');

      expect(entry.path, equals('Vehicle.Speed'));
      expect(entry.value, isNull);
      expect(entry.actuatorTarget, isNull);
      expect(entry.metadata, isNull);
    });

    test('toString works correctly', () {
      final entry = DataEntry(
        path: 'Vehicle.Speed',
        value: Datapoint(value: 100),
      );
      final str = entry.toString();

      expect(str, contains('Vehicle.Speed'));
      expect(str, contains('100'));
    });

    test('equality works correctly', () {
      final value = Datapoint(value: 100);
      final e1 = DataEntry(path: 'Vehicle.Speed', value: value);
      final e2 = DataEntry(path: 'Vehicle.Speed', value: value);
      final e3 = DataEntry(path: 'Vehicle.RPM', value: value);

      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
    });
  });
}
