# KUKSA Dart Client - Implementation Guide

## Overview

This document provides a comprehensive guide for completing the KUKSA Dart client implementation. The foundation has been laid with core data models, but protocol buffer integration and full gRPC implementation are still needed.

## Current Status

### ✅ Completed Components

1. **Package Structure**
   - Full Dart package layout with `lib/`, `test/`, `example/`
   - Proper `pubspec.yaml` with all dependencies
   - Linting configuration (`analysis_options.yaml`)
   - `.gitignore` for Dart artifacts

2. **Core Data Models** (`lib/src/models/`)
   - `enums.dart` - All 5 enumerations with full parity
   - `datapoint.dart` - Immutable Datapoint class
   - `metadata.dart` - Metadata and ValueRestriction
   - `data_entry.dart` - Complete DataEntry
   - `requests.dart` - EntryRequest, EntryUpdate, SubscribeEntry
   - `server_info.dart` - ServerInfo class
   - `exceptions.dart` - VSSClientError exception

3. **Client Structure** (`lib/src/grpc/`)
   - `vss_client.dart` - Basic VSSClient class with:
     - Connection management
     - TLS support structure
     - Method stubs for all operations
     - Error handling framework

4. **Testing**
   - Unit tests for all data models
   - Test infrastructure setup
   - Test vector generator (Python script)

5. **Documentation**
   - Comprehensive README with API mapping
   - Inline documentation for all public APIs
   - Usage examples (simple + advanced)
   - Verification report
   - Setup guide

### 🔄 Pending Work

1. **Protocol Buffer Integration** (HIGH PRIORITY)
2. **Complete VSSClient Implementation** (HIGH PRIORITY)
3. **Integration Testing** (MEDIUM PRIORITY)
4. **Parity Testing** (MEDIUM PRIORITY)

---

## Step-by-Step Completion Guide

### Step 1: Protocol Buffer Setup

The Python implementation uses these proto files:
- `kuksa.val.v1.val_pb2` - Protocol v1
- `kuksa.val.v1.val_pb2_grpc` - gRPC stubs v1
- `kuksa.val.v2.types_pb2` - Types v2
- `kuksa.val.v2.val_pb2_grpc` - gRPC stubs v2

#### 1.1 Find Proto Files

```bash
# In the Python package, find the proto source
cd ../kuksa-client
find . -name "*.proto"
```

Expected locations:
- `submodules/kuksa-common/proto/kuksa/val/v1/val.proto`
- `submodules/kuksa-common/proto/kuksa/val/v1/types.proto`

#### 1.2 Copy Proto Files to Dart Package

```bash
cd ../kuksa_client_dart
mkdir -p proto/kuksa/val/{v1,v2}

# Copy proto files (adjust paths as needed)
cp ../submodules/kuksa-common/proto/kuksa/val/v1/*.proto proto/kuksa/val/v1/
```

#### 1.3 Install protoc Compiler

```bash
# Ubuntu/Debian
sudo apt-get install -y protobuf-compiler

# macOS
brew install protobuf

# Or download from: https://github.com/protocolbuffers/protobuf/releases
```

#### 1.4 Install Dart protoc Plugin

```bash
dart pub global activate protoc_plugin
export PATH="$PATH:$HOME/.pub-cache/bin"
```

#### 1.5 Generate Dart Code

```bash
# Generate Dart code from proto files
protoc \
  --dart_out=grpc:lib/src/grpc/generated \
  --proto_path=proto \
  proto/kuksa/val/v1/*.proto
```

This creates:
- `*.pb.dart` - Message classes
- `*.pbenum.dart` - Enums
- `*.pbgrpc.dart` - gRPC client/server stubs
- `*.pbjson.dart` - JSON serialization

#### 1.6 Update pubspec.yaml

Ensure these are in `dev_dependencies`:

```yaml
dev_dependencies:
  protoc_plugin: ^21.1.0
```

---

### Step 2: Implement Proto Converters

Create `lib/src/utils/converters.dart` to convert between Dart models and proto messages.

#### Example Converter Structure:

```dart
import 'package:kuksa_client_dart/src/grpc/generated/kuksa/val/v1/val.pb.dart' as pb_v1;
import 'package:kuksa_client_dart/src/models/datapoint.dart';

class ProtoConverters {
  // Datapoint -> Proto
  static pb_v1.Datapoint toProtoDatapoint(Datapoint dp) {
    final proto = pb_v1.Datapoint();
    // Set fields based on value type
    if (dp.value is int) {
      proto.int32 = dp.value;
    } else if (dp.value is double) {
      proto.double_1 = dp.value;
    } // ... handle all types
    
    if (dp.timestamp != null) {
      proto.timestamp = dp.timestamp!.millisecondsSinceEpoch;
    }
    return proto;
  }
  
  // Proto -> Datapoint
  static Datapoint fromProtoDatapoint(pb_v1.Datapoint proto) {
    dynamic value;
    // Extract value based on which field is set
    if (proto.hasInt32()) value = proto.int32;
    else if (proto.hasDouble()) value = proto.double_1;
    // ... handle all types
    
    DateTime? timestamp;
    if (proto.hasTimestamp()) {
      timestamp = DateTime.fromMillisecondsSinceEpoch(proto.timestamp.toInt());
    }
    
    return Datapoint(value: value, timestamp: timestamp);
  }
  
  // Add converters for all model types
}
```

---

### Step 3: Complete VSSClient Implementation

Edit `lib/src/grpc/vss_client.dart` to implement all methods using proto.

#### 3.1 Add gRPC Stubs

```dart
import 'package:kuksa_client_dart/src/grpc/generated/kuksa/val/v1/val.pbgrpc.dart' as grpc_v1;
import 'package:kuksa_client_dart/src/grpc/generated/kuksa/val/v2/val.pbgrpc.dart' as grpc_v2;
import 'package:kuksa_client_dart/src/utils/converters.dart';

class VSSClient {
  // ... existing fields ...
  
  grpc_v1.VALClient? _clientStubV1;
  grpc_v2.VALClient? _clientStubV2;
  
  // ... existing methods ...
}
```

#### 3.2 Update connect() Method

```dart
Future<void> connect() async {
  // ... existing channel creation ...
  
  // Create gRPC stubs
  _clientStubV1 = grpc_v1.VALClient(_channel!);
  _clientStubV2 = grpc_v2.VALClient(_channel!);
  
  _connected = true;
  
  if (ensureStartupConnection) {
    await getServerInfo();
  }
}
```

#### 3.3 Implement getServerInfo()

```dart
Future<ServerInfo> getServerInfo() async {
  _ensureConnected();
  
  try {
    final request = grpc_v1.GetServerInfoRequest();
    final response = await _clientStubV1!.getServerInfo(request);
    
    return ServerInfo(
      name: response.name,
      version: response.version,
    );
  } catch (e) {
    throw VSSClientError.fromGrpcError(e);
  }
}
```

#### 3.4 Implement getCurrentValues()

```dart
Future<Map<String, Datapoint>> getCurrentValues(List<String> paths) async {
  _ensureConnected();
  
  try {
    final request = grpc_v1.GetRequest();
    for (final path in paths) {
      final entry = grpc_v1.EntryRequest();
      entry.path = path;
      entry.fields.add(grpc_v1.Field.FIELD_VALUE);
      request.entries.add(entry);
    }
    
    final response = await _clientStubV1!.get(request);
    
    final result = <String, Datapoint>{};
    for (final entry in response.entries) {
      if (entry.hasValue()) {
        result[entry.path] = ProtoConverters.fromProtoDatapoint(entry.value);
      }
    }
    
    return result;
  } catch (e) {
    throw VSSClientError.fromGrpcError(e);
  }
}
```

#### 3.5 Implement setCurrentValues()

```dart
Future<void> setCurrentValues(Map<String, dynamic> updates) async {
  _ensureConnected();
  
  try {
    final request = grpc_v1.SetRequest();
    
    for (final entry in updates.entries) {
      final update = grpc_v1.EntryUpdate();
      update.entry.path = entry.key;
      update.entry.value = ProtoConverters.toProtoDatapoint(
        Datapoint(value: entry.value),
      );
      update.fields.add(grpc_v1.Field.FIELD_VALUE);
      request.updates.add(update);
    }
    
    await _clientStubV1!.set(request);
  } catch (e) {
    throw VSSClientError.fromGrpcError(e);
  }
}
```

#### 3.6 Implement subscribeCurrentValues()

```dart
Stream<List<DataEntry>> subscribeCurrentValues(List<String> paths) async* {
  _ensureConnected();
  
  try {
    final request = grpc_v1.SubscribeRequest();
    for (final path in paths) {
      final entry = grpc_v1.SubscribeEntry();
      entry.path = path;
      entry.fields.add(grpc_v1.Field.FIELD_VALUE);
      request.entries.add(entry);
    }
    
    final stream = _clientStubV1!.subscribe(request);
    
    await for (final response in stream) {
      final entries = <DataEntry>[];
      for (final update in response.updates) {
        final dataEntry = DataEntry(
          path: update.entry.path,
          value: update.entry.hasValue()
              ? ProtoConverters.fromProtoDatapoint(update.entry.value)
              : null,
        );
        entries.add(dataEntry);
      }
      yield entries;
    }
  } catch (e) {
    throw VSSClientError.fromGrpcError(e);
  }
}
```

Repeat this pattern for:
- `getTargetValues()`
- `setTargetValues()`
- `getMetadata()`
- `subscribeTargetValues()`
- `authorize()`

---

### Step 4: Implement Error Handling

Update `exceptions.dart` to properly handle gRPC errors:

```dart
factory VSSClientError.fromGrpcError(dynamic error) {
  if (error is GrpcError) {
    return VSSClientError(
      message: error.message ?? 'gRPC error',
      code: error.code,
      details: {'grpcCode': error.codeName},
    );
  }
  return VSSClientError(
    message: error.toString(),
  );
}
```

---

### Step 5: Testing

#### 5.1 Run Unit Tests

```bash
dart test test/models/
```

All model tests should pass.

#### 5.2 Create Integration Test

Create `test/integration/client_test.dart`:

```dart
import 'package:test/test.dart';
import 'package:kuksa_client_dart/kuksa_client_dart.dart';

void main() {
  group('VSSClient Integration', () {
    late VSSClient client;
    
    setUp(() async {
      client = VSSClient(
        targetHost: '127.0.0.1:55555',
        ensureStartupConnection: false,
      );
      await client.connect();
    });
    
    tearDown(() async {
      await client.disconnect();
    });
    
    test('getServerInfo returns valid info', () async {
      final info = await client.getServerInfo();
      expect(info.name, isNotEmpty);
      expect(info.version, isNotEmpty);
    });
    
    test('getCurrentValues works', () async {
      // Assuming test data exists
      final values = await client.getCurrentValues(['Vehicle.Speed']);
      expect(values, isNotEmpty);
    });
  });
}
```

Run with a live databroker:

```bash
# Start databroker
docker run -d -p 55555:55555 ghcr.io/eclipse-kuksa/kuksa-databroker:latest

# Run integration tests
dart test test/integration/
```

#### 5.3 Create Parity Tests

Create `test/parity/parity_test.dart`:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:kuksa_client_dart/kuksa_client_dart.dart';

void main() {
  group('Parity Tests', () {
    late Map<String, dynamic> testVectors;
    
    setUpAll(() {
      // Load test vectors generated by Python
      final file = File('test/parity/test_vectors.json');
      testVectors = jsonDecode(file.readAsStringSync());
    });
    
    test('Datapoint matches Python output', () {
      final tests = testVectors['tests']
          .where((t) => t['type'] == 'Datapoint')
          .toList();
      
      for (final testCase in tests) {
        final input = testCase['input'];
        final expected = testCase['expected'];
        
        final dp = Datapoint(
          value: input['value'],
          timestamp: input['timestamp'] != null
              ? DateTime.parse(input['timestamp'])
              : null,
        );
        
        expect(dp.value, equals(expected['value']));
        // Add more assertions
      }
    });
  });
}
```

---

### Step 6: Documentation Updates

Once implementation is complete:

1. **Update README.md**:
   - Change status from "stub" to "implemented"
   - Add real usage examples with actual outputs

2. **Update VERIFICATION_REPORT.md**:
   - Mark completed features as ✅
   - Update status to 100%
   - Add performance benchmarks

3. **Add API Documentation**:
   - Generate dartdoc: `dart doc`
   - Host on GitHub Pages or pub.dev

---

## Testing Checklist

Before marking complete, verify:

- [ ] All unit tests pass (`dart test test/models/`)
- [ ] All integration tests pass (against live databroker)
- [ ] All parity tests pass (Dart outputs match Python)
- [ ] Code analyzer shows no errors (`dart analyze`)
- [ ] Code is formatted (`dart format .`)
- [ ] Examples run successfully
- [ ] Documentation is up-to-date
- [ ] VERIFICATION_REPORT.md reflects actual status

---

## Known Challenges

### 1. Proto Field Naming
Proto generates fields like `double_1` instead of `double`. Handle carefully.

### 2. Timestamp Conversion
Python uses datetime, proto uses int64 microseconds. Ensure proper conversion.

### 3. Value Type Detection
Dynamic typing in Dart requires runtime type checks. Use `is` operator.

### 4. Stream Cancellation
Ensure streams are properly cancelled to avoid memory leaks.

### 5. gRPC Error Mapping
Map gRPC StatusCode to meaningful error messages.

---

## Performance Optimization

Once basic implementation works:

1. **Connection Pooling**: Reuse channels when possible
2. **Batch Operations**: Combine multiple get/set calls
3. **Stream Buffering**: Use `.buffer()` for high-frequency updates
4. **Lazy Initialization**: Only create stubs when needed
5. **Metadata Caching**: Cache metadata to reduce server calls

---

## Publishing to pub.dev

When ready to publish:

```bash
# Verify package structure
dart pub publish --dry-run

# Publish (requires authentication)
dart pub publish
```

Checklist:
- [ ] Version in pubspec.yaml follows semver
- [ ] CHANGELOG.md is updated
- [ ] LICENSE file is present
- [ ] README.md is comprehensive
- [ ] All tests pass
- [ ] No TODOs in public APIs

---

## Support Resources

- **Dart Language**: https://dart.dev/guides
- **gRPC Dart**: https://grpc.io/docs/languages/dart/
- **Protocol Buffers**: https://developers.google.com/protocol-buffers
- **KUKSA Databroker**: https://github.com/eclipse-kuksa/kuksa-databroker
- **VSS Specification**: https://covesa.github.io/vehicle_signal_specification/

---

## Conclusion

The foundation is complete and robust. The main remaining work is mechanical:
1. Generate proto code
2. Wire up converters
3. Implement method bodies
4. Test thoroughly

Estimated time to completion: 4-8 hours for a developer familiar with Dart and gRPC.

Good luck! 🚀
