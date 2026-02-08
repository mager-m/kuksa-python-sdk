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

import 'dart:async';
import 'dart:io';
import 'package:grpc/grpc.dart';
import '../models/data_entry.dart';
import '../models/datapoint.dart';
import '../models/exceptions.dart';
import '../models/metadata.dart';
import '../models/server_info.dart';

/// VSS Client for communicating with KUKSA Databroker via gRPC
class VSSClient {
  /// Target host (e.g., "127.0.0.1:55555")
  final String targetHost;

  /// Root CA certificate for TLS (optional)
  final String? rootCaPath;

  /// TLS server name override (optional)
  final String? tlsServerName;

  /// JWT token for authorization (optional)
  final String? token;

  /// Ensure connection at startup
  final bool ensureStartupConnection;

  /// gRPC client channel
  ClientChannel? _channel;

  /// Whether connected to server
  bool _connected = false;

  /// Path to ID mapping (for protocol v2)
  final Map<String, int> _pathToIdMapping = {};

  /// ID to path mapping (for protocol v2)
  final Map<int, String> _idToPathMapping = {};

  VSSClient({
    this.targetHost = '127.0.0.1:55555',
    this.rootCaPath,
    this.tlsServerName,
    this.token,
    this.ensureStartupConnection = true,
  });

  /// Check if client is connected
  bool get isConnected => _connected;

  /// Connect to the KUKSA Databroker
  Future<void> connect() async {
    _pathToIdMapping.clear();
    _idToPathMapping.clear();

    try {
      if (rootCaPath != null) {
        // Create secure channel with TLS
        final trustedRoot = await File(rootCaPath!).readAsBytes();
        final channelCredentials = ChannelCredentials.secure(
          certificates: trustedRoot,
          authority: tlsServerName,
        );
        _channel = ClientChannel(
          targetHost.split(':')[0],
          port: int.parse(targetHost.split(':')[1]),
          options: ChannelOptions(credentials: channelCredentials),
        );
      } else {
        // Create insecure channel
        _channel = ClientChannel(
          targetHost.split(':')[0],
          port: int.parse(targetHost.split(':')[1]),
          options: const ChannelOptions(
            credentials: ChannelCredentials.insecure(),
          ),
        );
      }

      _connected = true;

      if (ensureStartupConnection) {
        // Verify connection by getting server info
        await getServerInfo();
      }
    } catch (e) {
      _connected = false;
      throw VSSClientError(
        message: 'Failed to connect to $targetHost: $e',
      );
    }
  }

  /// Disconnect from the KUKSA Databroker
  Future<void> disconnect() async {
    await _channel?.shutdown();
    _channel = null;
    _connected = false;
  }

  /// Get server information
  Future<ServerInfo> getServerInfo() async {
    _ensureConnected();

    // This will be implemented when we add proto support
    // For now, return placeholder
    return const ServerInfo(
      name: 'KUKSA Databroker',
      version: '0.0.0',
    );
  }

  /// Get current values for specified paths
  ///
  /// Returns a map of path to Datapoint for each requested path
  Future<Map<String, Datapoint>> getCurrentValues(
    List<String> paths,
  ) async {
    _ensureConnected();

    // This will be implemented with proto support
    throw UnimplementedError('getCurrentValues not yet implemented');
  }

  /// Set current values for specified paths
  ///
  /// [updates] - Map of path to value
  Future<void> setCurrentValues(Map<String, dynamic> updates) async {
    _ensureConnected();

    // This will be implemented with proto support
    throw UnimplementedError('setCurrentValues not yet implemented');
  }

  /// Get target values for specified actuator paths
  Future<Map<String, Datapoint>> getTargetValues(
    List<String> paths,
  ) async {
    _ensureConnected();

    // This will be implemented with proto support
    throw UnimplementedError('getTargetValues not yet implemented');
  }

  /// Set target values for specified actuator paths
  Future<void> setTargetValues(Map<String, dynamic> updates) async {
    _ensureConnected();

    // This will be implemented with proto support
    throw UnimplementedError('setTargetValues not yet implemented');
  }

  /// Get metadata for specified paths
  Future<Map<String, Metadata>> getMetadata(List<String> paths) async {
    _ensureConnected();

    // This will be implemented with proto support
    throw UnimplementedError('getMetadata not yet implemented');
  }

  /// Subscribe to current value changes
  ///
  /// Returns a stream of DataEntry updates
  Stream<List<DataEntry>> subscribeCurrentValues(
    List<String> paths,
  ) async* {
    _ensureConnected();

    // This will be implemented with proto support
    throw UnimplementedError('subscribeCurrentValues not yet implemented');
  }

  /// Subscribe to target value changes
  Stream<List<DataEntry>> subscribeTargetValues(
    List<String> paths,
  ) async* {
    _ensureConnected();

    // This will be implemented with proto support
    throw UnimplementedError('subscribeTargetValues not yet implemented');
  }

  /// Authorize with JWT token
  Future<void> authorize(String tokenOrTokenFile) async {
    _ensureConnected();

    // This will be implemented with proto support
    throw UnimplementedError('authorize not yet implemented');
  }

  void _ensureConnected() {
    if (!_connected || _channel == null) {
      throw VSSClientError(
        message: 'Not connected to server. Call connect() first.',
      );
    }
  }
}
