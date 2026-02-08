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

/// Data types supported by VSS (Vehicle Signal Specification)
enum DataType {
  string,
  boolean,
  int8,
  int16,
  int32,
  int64,
  uint8,
  uint16,
  uint32,
  uint64,
  float,
  double,
  int8Array,
  int16Array,
  int32Array,
  int64Array,
  uint8Array,
  uint16Array,
  uint32Array,
  uint64Array,
  floatArray,
  doubleArray,
  stringArray,
  booleanArray,
  timestamp,
}

/// Entry types in the VSS tree
enum EntryType {
  attribute,
  sensor,
  actuator,
}

/// Views that can be requested for data entries
enum View {
  unspecified,
  currentValue,
  targetValue,
  metadata,
  fields,
  all,
}

/// Fields that can be requested or updated
enum Field {
  unspecified,
  path,
  value,
  actuatorTarget,
  metadata,
  metadataDataType,
  metadataDescription,
  metadataEntryType,
  metadataComment,
  metadataDeprecation,
  metadataUnit,
  metadataValueRestriction,
  metadataActuator,
  metadataAttribute,
  metadataSensor,
}

/// Metadata-specific fields
enum MetadataField {
  unspecified,
  dataType,
  description,
  entryType,
  comment,
  deprecation,
  unit,
  valueRestriction,
  actuator,
  attribute,
  sensor,
}
