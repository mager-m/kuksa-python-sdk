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

/// Request for data entry with specified view and fields
class EntryRequest {
  /// The path in the VSS tree
  final String path;

  /// The view to request
  final View view;

  /// Specific fields to request
  final List<Field> fields;

  const EntryRequest({
    required this.path,
    this.view = View.unspecified,
    this.fields = const [],
  });

  @override
  String toString() {
    return 'EntryRequest(path: $path, view: $view, fields: $fields)';
  }
}

/// Update for a data entry with specified fields
class EntryUpdate {
  /// The data entry to update
  final DataEntry entry;

  /// Fields that are being updated
  final List<Field> fields;

  const EntryUpdate({
    required this.entry,
    this.fields = const [],
  });

  @override
  String toString() {
    return 'EntryUpdate(entry: $entry, fields: $fields)';
  }
}

/// Subscription request for data entry
class SubscribeEntry {
  /// The path in the VSS tree (supports wildcards)
  final String path;

  /// The view to subscribe to
  final View view;

  /// Specific fields to subscribe to
  final List<Field> fields;

  const SubscribeEntry({
    required this.path,
    this.view = View.unspecified,
    this.fields = const [],
  });

  @override
  String toString() {
    return 'SubscribeEntry(path: $path, view: $view, fields: $fields)';
  }
}

// Re-export DataEntry from data_entry.dart
export 'data_entry.dart' show DataEntry;
