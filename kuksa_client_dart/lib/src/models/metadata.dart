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

import 'enums.dart';

/// Restriction on allowed values for a data entry
class ValueRestriction {
  /// Minimum allowed value (for numeric types)
  final dynamic min;

  /// Maximum allowed value (for numeric types)
  final dynamic max;

  /// List of allowed values (for enumerated types)
  final List<dynamic>? allowedValues;

  const ValueRestriction({
    this.min,
    this.max,
    this.allowedValues,
  });

  @override
  String toString() {
    final parts = <String>[];
    if (min != null) parts.add('min: $min');
    if (max != null) parts.add('max: $max');
    if (allowedValues != null) parts.add('allowedValues: $allowedValues');
    return 'ValueRestriction(${parts.join(', ')})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueRestriction &&
        other.min == min &&
        other.max == max &&
        _listEquals(other.allowedValues, allowedValues);
  }

  @override
  int get hashCode => Object.hash(min, max, allowedValues);

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Metadata describing a VSS entry
class Metadata {
  /// Data type of the entry
  final DataType? dataType;

  /// Entry type (attribute, sensor, actuator)
  final EntryType? entryType;

  /// Human-readable description
  final String? description;

  /// Additional comment
  final String? comment;

  /// Deprecation notice
  final String? deprecation;

  /// Unit of measurement (e.g., "km/h", "celsius")
  final String? unit;

  /// Value restrictions
  final ValueRestriction? valueRestriction;

  /// Actuator-specific metadata
  final Map<String, dynamic>? actuator;

  /// Attribute-specific metadata
  final Map<String, dynamic>? attribute;

  /// Sensor-specific metadata
  final Map<String, dynamic>? sensor;

  const Metadata({
    this.dataType,
    this.entryType,
    this.description,
    this.comment,
    this.deprecation,
    this.unit,
    this.valueRestriction,
    this.actuator,
    this.attribute,
    this.sensor,
  });

  @override
  String toString() {
    return 'Metadata(dataType: $dataType, entryType: $entryType, '
        'description: $description, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Metadata &&
        other.dataType == dataType &&
        other.entryType == entryType &&
        other.description == description &&
        other.comment == comment &&
        other.deprecation == deprecation &&
        other.unit == unit &&
        other.valueRestriction == valueRestriction;
  }

  @override
  int get hashCode => Object.hash(
        dataType,
        entryType,
        description,
        comment,
        deprecation,
        unit,
        valueRestriction,
      );
}
