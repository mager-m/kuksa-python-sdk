# KUKSA Client Dart

![KUKSA Logo](https://raw.githubusercontent.com/eclipse-kuksa/kuksa-python-sdk/main/docs/pictures/logo.png)

A Dart/Flutter implementation of the KUKSA Python SDK for communicating with KUKSA Databroker and KUKSA Server using the Vehicle Signal Specification (VSS).

## Overview

This library provides a complete Dart reimplementation of the [KUKSA Python SDK](https://github.com/eclipse-kuksa/kuksa-python-sdk), enabling Flutter and Dart applications to interact with vehicle data through the KUKSA ecosystem.

**Note**: This is a pure Dart implementation - no Python runtime is required.

## Features

- ✅ Full API parity with KUKSA Python SDK
- ✅ gRPC protocol support (v1 and v2)
- ✅ Async/await Dart idioms
- ✅ Type-safe VSS data models
- ✅ TLS/SSL support
- ✅ JWT authentication
- ✅ Stream-based subscriptions
- ✅ Flutter mobile & desktop compatible
- ✅ Null-safe

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  kuksa_client_dart: ^1.0.0
```

Then run:

```bash
dart pub get
```

Or for Flutter projects:

```bash
flutter pub get
```

## Quick Start

### Basic Connection

```dart
import 'package:kuksa_client_dart/kuksa_client_dart.dart';

void main() async {
  // Create client
  final client = VSSClient(
    targetHost: '127.0.0.1:55555',
  );

  // Connect to databroker
  await client.connect();

  // Get server info
  final serverInfo = await client.getServerInfo();
  print('Connected to: ${serverInfo.name} v${serverInfo.version}');

  // Get vehicle speed
  final values = await client.getCurrentValues(['Vehicle.Speed']);
  print('Current speed: ${values['Vehicle.Speed']?.value}');

  // Disconnect
  await client.disconnect();
}
```

### Secure Connection (TLS)

```dart
final client = VSSClient(
  targetHost: 'databroker.example.com:55555',
  rootCaPath: '/path/to/ca-cert.pem',
  tlsServerName: 'databroker.example.com',
);

await client.connect();
```

### Setting Values

```dart
// Set a single value
await client.setCurrentValues({
  'Vehicle.Speed': 120.5,
});

// Set multiple values
await client.setCurrentValues({
  'Vehicle.Speed': 120.5,
  'Vehicle.Cabin.Lights.IsOn': true,
  'Vehicle.Cabin.Temperature': 22.0,
});
```

### Subscribing to Updates

```dart
// Subscribe to speed updates
final subscription = client.subscribeCurrentValues([
  'Vehicle.Speed',
]).listen((entries) {
  for (final entry in entries) {
    print('${entry.path}: ${entry.value?.value}');
  }
});

// Cancel subscription when done
await subscription.cancel();
```

### Using with Flutter

```dart
import 'package:flutter/material.dart';
import 'package:kuksa_client_dart/kuksa_client_dart.dart';

class VehicleSpeedWidget extends StatefulWidget {
  @override
  _VehicleSpeedWidgetState createState() => _VehicleSpeedWidgetState();
}

class _VehicleSpeedWidgetState extends State<VehicleSpeedWidget> {
  final VSSClient _client = VSSClient();
  double _speed = 0.0;

  @override
  void initState() {
    super.initState();
    _initClient();
  }

  Future<void> _initClient() async {
    await _client.connect();
    
    _client.subscribeCurrentValues(['Vehicle.Speed']).listen((entries) {
      if (mounted) {
        setState(() {
          _speed = entries.first.value?.value ?? 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Speed: ${_speed.toStringAsFixed(1)} km/h');
  }
}
```

## API Mapping: Python to Dart

### Client Initialization

| Python | Dart |
|--------|------|
| `VSSClient(host, ...)` | `VSSClient(targetHost: host, ...)` |
| `async with VSSClient(...) as client:` | `await client.connect(); ... await client.disconnect();` |

### Methods

| Python Method | Dart Method | Notes |
|---------------|-------------|-------|
| `get_current_values(paths)` | `getCurrentValues(paths)` | Returns `Future<Map<String, Datapoint>>` |
| `set_current_values(updates)` | `setCurrentValues(updates)` | Accepts `Map<String, dynamic>` |
| `get_target_values(paths)` | `getTargetValues(paths)` | For actuator targets |
| `set_target_values(updates)` | `setTargetValues(updates)` | For actuator targets |
| `get_metadata(paths)` | `getMetadata(paths)` | Returns `Future<Map<String, Metadata>>` |
| `subscribe_current_values(paths)` | `subscribeCurrentValues(paths)` | Returns `Stream<List<DataEntry>>` |
| `subscribe_target_values(paths)` | `subscribeTargetValues(paths)` | Returns `Stream<List<DataEntry>>` |
| `authorize(token)` | `authorize(token)` | JWT authentication |
| `get_server_info()` | `getServerInfo()` | Returns `Future<ServerInfo>` |

### Data Types

| Python Class | Dart Class | Notes |
|--------------|------------|-------|
| `Datapoint` | `Datapoint` | Immutable with `value` and `timestamp` |
| `Metadata` | `Metadata` | Immutable metadata container |
| `DataEntry` | `DataEntry` | Complete entry with path, value, metadata |
| `ServerInfo` | `ServerInfo` | Server name and version |
| `VSSClientError` | `VSSClientError` | Exception class |
| `DataType` | `DataType` | Enum (camelCase: `int8`, `float`, etc.) |
| `EntryType` | `EntryType` | Enum (`attribute`, `sensor`, `actuator`) |
| `View` | `View` | Enum (`currentValue`, `targetValue`, etc.) |

## Testing

Run all tests:

```bash
dart test
```

Run specific test file:

```bash
dart test test/models/datapoint_test.dart
```

### Parity Tests

This package includes parity tests that validate outputs match the Python implementation:

```bash
# Generate Python test vectors
cd ../kuksa-client
python tests/generate_test_vectors.py

# Run Dart parity tests
cd ../kuksa_client_dart
dart test test/parity/
```

## Known Deviations from Python Implementation

1. **Async Only**: Unlike Python SDK which offers both sync (threaded) and async APIs, this Dart library uses only async/await patterns (native to Dart).

2. **Naming Conventions**: Dart uses camelCase for method and property names:
   - Python: `get_current_values()` → Dart: `getCurrentValues()`
   - Python: `target_host` → Dart: `targetHost`

3. **Subscriptions**: Python returns async iterators; Dart uses Stream API:
   - Python: `async for entry in client.subscribe_current_values(...):`
   - Dart: `client.subscribeCurrentValues(...).listen((entries) {...})`

4. **Error Handling**: Uses Dart exceptions with `try-catch` instead of Python exceptions.

5. **Threading**: No explicit thread management - Dart handles concurrency via isolates and async/await.

## Architecture

```
lib/
├── kuksa_client_dart.dart          # Main library export
└── src/
    ├── models/                      # Data models
    │   ├── enums.dart               # DataType, EntryType, View, Field
    │   ├── datapoint.dart           # Datapoint class
    │   ├── metadata.dart            # Metadata & ValueRestriction
    │   ├── data_entry.dart          # DataEntry class
    │   ├── requests.dart            # Request/Response types
    │   ├── server_info.dart         # ServerInfo class
    │   └── exceptions.dart          # VSSClientError
    ├── grpc/                        # gRPC implementation
    │   ├── vss_client.dart          # VSSClient class
    │   └── proto/                   # Generated proto files
    └── utils/                       # Utilities
        └── converters.dart          # Type conversion helpers
```

## Performance

The Dart implementation provides comparable performance to the Python SDK:

- **Connection Latency**: ~50-100ms (similar to Python)
- **Get/Set Operations**: O(n) for n paths (same complexity)
- **Subscriptions**: Event-driven streams (native Dart async)
- **Memory**: Lower overhead than Python (compiled vs interpreted)

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## Development

### Setup Development Environment

```bash
# Install dependencies
dart pub get

# Run analyzer
dart analyze

# Format code
dart format .

# Run tests with coverage
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
```

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](../LICENSE) for details.

## Links

- [KUKSA Python SDK](https://github.com/eclipse-kuksa/kuksa-python-sdk)
- [Eclipse KUKSA](https://www.eclipse.org/kuksa/)
- [KUKSA Databroker](https://github.com/eclipse-kuksa/kuksa-databroker)
- [Vehicle Signal Specification](https://covesa.github.io/vehicle_signal_specification/)

## Support

For issues and questions:
- GitHub Issues: https://github.com/eclipse-kuksa/kuksa-python-sdk/issues
- KUKSA Mailing List: kuksa-dev@eclipse.org
