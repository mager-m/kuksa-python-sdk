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

/// Exception thrown by VSS client operations
class VSSClientError implements Exception {
  /// Error message
  final String message;

  /// Error code (if available)
  final int? code;

  /// Additional error details
  final Map<String, dynamic>? details;

  /// List of individual errors
  final List<Map<String, dynamic>>? errors;

  const VSSClientError({
    required this.message,
    this.code,
    this.details,
    this.errors,
  });

  /// Create VSSClientError from gRPC error
  factory VSSClientError.fromGrpcError(dynamic error) {
    // This will be implemented when we add gRPC support
    return VSSClientError(
      message: error.toString(),
      code: null,
      details: null,
      errors: null,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('VSSClientError: $message');
    if (code != null) {
      buffer.write(' (code: $code)');
    }
    if (errors != null && errors!.isNotEmpty) {
      buffer.write('\nErrors: $errors');
    }
    return buffer.toString();
  }
}
