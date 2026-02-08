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
  group('Datapoint', () {
    test('creates datapoint with value and timestamp', () {
      final timestamp = DateTime.now();
      final datapoint = Datapoint(
        value: 120.5,
        timestamp: timestamp,
      );

      expect(datapoint.value, equals(120.5));
      expect(datapoint.timestamp, equals(timestamp));
    });

    test('creates datapoint with null timestamp', () {
      final datapoint = Datapoint(value: 'test');

      expect(datapoint.value, equals('test'));
      expect(datapoint.timestamp, isNull);
    });

    test('supports different value types', () {
      expect(Datapoint(value: 42).value, equals(42));
      expect(Datapoint(value: 3.14).value, equals(3.14));
      expect(Datapoint(value: 'hello').value, equals('hello'));
      expect(Datapoint(value: true).value, equals(true));
      expect(Datapoint(value: [1, 2, 3]).value, equals([1, 2, 3]));
    });

    test('equality works correctly', () {
      final timestamp = DateTime.now();
      final dp1 = Datapoint(value: 100, timestamp: timestamp);
      final dp2 = Datapoint(value: 100, timestamp: timestamp);
      final dp3 = Datapoint(value: 200, timestamp: timestamp);

      expect(dp1, equals(dp2));
      expect(dp1, isNot(equals(dp3)));
    });

    test('hashCode works correctly', () {
      final timestamp = DateTime.now();
      final dp1 = Datapoint(value: 100, timestamp: timestamp);
      final dp2 = Datapoint(value: 100, timestamp: timestamp);

      expect(dp1.hashCode, equals(dp2.hashCode));
    });

    test('toString includes value and timestamp', () {
      final timestamp = DateTime.now();
      final datapoint = Datapoint(value: 42, timestamp: timestamp);
      final str = datapoint.toString();

      expect(str, contains('42'));
      expect(str, contains('Datapoint'));
    });
  });
}
