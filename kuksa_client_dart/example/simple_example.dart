import 'package:kuksa_client_dart/kuksa_client_dart.dart';

/// Simple example of using the KUKSA Dart client
Future<void> main() async {
  print('KUKSA Dart Client Example\n');

  // Create client
  final client = VSSClient(
    targetHost: '127.0.0.1:55555',
  );

  try {
    // Connect to databroker
    print('Connecting to KUKSA Databroker...');
    await client.connect();
    print('✓ Connected!');

    // Get server info
    print('\nGetting server info...');
    final serverInfo = await client.getServerInfo();
    print('✓ Server: ${serverInfo.name} v${serverInfo.version}');

    // Example 1: Get current values
    print('\nExample 1: Getting vehicle speed...');
    try {
      final values = await client.getCurrentValues(['Vehicle.Speed']);
      final speed = values['Vehicle.Speed'];
      if (speed != null) {
        print('✓ Current speed: ${speed.value} (timestamp: ${speed.timestamp})');
      }
    } catch (e) {
      print('✗ Error: $e');
    }

    // Example 2: Set values
    print('\nExample 2: Setting cabin temperature...');
    try {
      await client.setCurrentValues({
        'Vehicle.Cabin.Temperature': 22.5,
      });
      print('✓ Temperature set to 22.5°C');
    } catch (e) {
      print('✗ Error: $e');
    }

    // Example 3: Get metadata
    print('\nExample 3: Getting metadata for Vehicle.Speed...');
    try {
      final metadata = await client.getMetadata(['Vehicle.Speed']);
      final speedMeta = metadata['Vehicle.Speed'];
      if (speedMeta != null) {
        print('✓ Data type: ${speedMeta.dataType}');
        print('  Entry type: ${speedMeta.entryType}');
        print('  Unit: ${speedMeta.unit}');
        print('  Description: ${speedMeta.description}');
      }
    } catch (e) {
      print('✗ Error: $e');
    }

    // Example 4: Subscribe to updates
    print('\nExample 4: Subscribing to speed updates for 5 seconds...');
    try {
      var updateCount = 0;
      final subscription = client.subscribeCurrentValues([
        'Vehicle.Speed',
      ]).listen((entries) {
        for (final entry in entries) {
          updateCount++;
          print('  Update #$updateCount: ${entry.path} = ${entry.value?.value}');
        }
      });

      // Wait for 5 seconds
      await Future.delayed(Duration(seconds: 5));
      await subscription.cancel();
      print('✓ Subscription cancelled after $updateCount updates');
    } catch (e) {
      print('✗ Error: $e');
    }

    print('\n✓ All examples completed!');
  } catch (e) {
    print('✗ Error: $e');
  } finally {
    // Disconnect
    print('\nDisconnecting...');
    await client.disconnect();
    print('✓ Disconnected');
  }
}
