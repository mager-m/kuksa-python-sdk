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

import 'datapoint.dart';
import 'metadata.dart';

/// Represents a complete data entry in the VSS tree
class DataEntry {
  /// The path in the VSS tree (e.g., "Vehicle.Speed")
  final String path;

  /// The current value
  final Datapoint? value;

  /// The actuator target value
  final Datapoint? actuatorTarget;

  /// Metadata for this entry
  final Metadata? metadata;

  const DataEntry({
    required this.path,
    this.value,
    this.actuatorTarget,
    this.metadata,
  });

  @override
  String toString() {
    return 'DataEntry(path: $path, value: $value, '
        'actuatorTarget: $actuatorTarget, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataEntry &&
        other.path == path &&
        other.value == value &&
        other.actuatorTarget == actuatorTarget &&
        other.metadata == metadata;
  }

  @override
  int get hashCode => Object.hash(path, value, actuatorTarget, metadata);
}
