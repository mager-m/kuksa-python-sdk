# Dart/Flutter Setup and Testing Guide

## Prerequisites

This project requires Dart SDK 3.0.0 or higher. You can install it in one of the following ways:

### Option 1: Install Dart SDK Only

```bash
# On Ubuntu/Debian
sudo apt-get update
sudo apt-get install apt-transport-https
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
sudo apt-get update
sudo apt-get install dart

# On macOS
brew tap dart-lang/dart
brew install dart

# On Windows
choco install dart-sdk
```

### Option 2: Install Flutter (includes Dart)

```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Run flutter doctor
flutter doctor
```

## Setup

1. **Navigate to the Dart package directory**:
   ```bash
   cd kuksa_client_dart
   ```

2. **Get dependencies**:
   ```bash
   dart pub get
   ```

3. **Verify installation**:
   ```bash
   dart --version
   ```

## Running Tests

### Run All Tests

```bash
dart test
```

### Run Specific Test File

```bash
dart test test/models/datapoint_test.dart
```

### Run Tests with Coverage

```bash
dart test --coverage=coverage
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
```

### Run Analyzer (Linter)

```bash
dart analyze
```

### Format Code

```bash
dart format lib test
```

## Generating Test Vectors

The test vectors are used for parity testing between Python and Dart implementations:

```bash
# Generate test vectors using Python
python3 scripts/generate_test_vectors.py > test/parity/test_vectors.json

# Run parity tests
dart test test/parity/
```

## Running Examples

```bash
# Simple example
dart run example/simple_example.dart

# Subscription example
dart run example/subscription_example.dart
```

## Using in a Flutter App

### 1. Add Dependency

In your Flutter app's `pubspec.yaml`:

```yaml
dependencies:
  kuksa_client_dart:
    path: ../kuksa_client_dart
```

Or from pub.dev (when published):

```yaml
dependencies:
  kuksa_client_dart: ^1.0.0
```

### 2. Import and Use

```dart
import 'package:kuksa_client_dart/kuksa_client_dart.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final client = VSSClient();
    // Use client...
  }
}
```

## Development Workflow

1. **Make changes** to source files in `lib/`
2. **Run analyzer**: `dart analyze`
3. **Format code**: `dart format .`
4. **Run tests**: `dart test`
5. **Generate coverage**: `dart test --coverage=coverage`
6. **Commit changes**

## Troubleshooting

### Dart SDK not found

Ensure Dart is in your PATH:
```bash
export PATH="$PATH:/usr/lib/dart/bin"
```

### Dependencies not resolving

Clear cache and re-fetch:
```bash
dart pub cache clean
dart pub get
```

### Tests failing

Ensure you're using Dart SDK 3.0.0 or higher:
```bash
dart --version
```

### gRPC proto files not found

The proto integration is still in progress. Once complete, you'll need to:
```bash
# Generate Dart code from proto files
protoc --dart_out=grpc:lib/src/grpc/proto *.proto
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Dart Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: stable
      - run: cd kuksa_client_dart && dart pub get
      - run: cd kuksa_client_dart && dart analyze
      - run: cd kuksa_client_dart && dart test
```

## Next Steps

1. Complete protocol buffer integration
2. Implement full VSSClient methods
3. Add integration tests
4. Publish to pub.dev

## Support

- GitHub Issues: https://github.com/eclipse-kuksa/kuksa-python-sdk/issues
- KUKSA Documentation: https://github.com/eclipse-kuksa/kuksa-python-sdk/tree/main/docs
