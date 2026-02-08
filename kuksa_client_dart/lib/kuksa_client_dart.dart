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

/// KUKSA Client Library for Dart/Flutter
///
/// This library provides a Dart implementation of the KUKSA Python SDK,
/// enabling communication with KUKSA Databroker for Vehicle Signal
/// Specification (VSS) data.
library kuksa_client_dart;

// Export all model classes
export 'src/models/enums.dart';
export 'src/models/datapoint.dart';
export 'src/models/metadata.dart';
export 'src/models/data_entry.dart';
export 'src/models/requests.dart';
export 'src/models/server_info.dart';
export 'src/models/exceptions.dart';

// Export gRPC client (will be implemented)
export 'src/grpc/vss_client.dart';
