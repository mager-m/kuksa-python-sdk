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

/// Represents a single data point with a value and timestamp
class Datapoint {
  /// The value of the datapoint (can be any type)
  final dynamic value;

  /// The timestamp when the value was set/read
  final DateTime? timestamp;

  const Datapoint({
    required this.value,
    this.timestamp,
  });

  @override
  String toString() {
    return 'Datapoint(value: $value, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Datapoint &&
        other.value == value &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => Object.hash(value, timestamp);
}
