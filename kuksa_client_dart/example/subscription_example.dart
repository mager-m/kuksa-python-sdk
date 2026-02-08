import 'package:kuksa_client_dart/kuksa_client_dart.dart';

/// Advanced example showing subscription and real-time updates
Future<void> main() async {
  print('KUKSA Dart Client - Advanced Subscription Example\n');

  final client = VSSClient(
    targetHost: '127.0.0.1:55555',
    ensureStartupConnection: true,
  );

  try {
    await client.connect();
    print('✓ Connected to KUKSA Databroker');

    // Subscribe to multiple signals
    print('\nSubscribing to multiple signals...');
    final signals = [
      'Vehicle.Speed',
      'Vehicle.Powertrain.Engine.Speed',
      'Vehicle.Cabin.Temperature',
    ];

    final subscription = client.subscribeCurrentValues(signals).listen(
      (entries) {
        print('\n[${DateTime.now()}] Received update:');
        for (final entry in entries) {
          final value = entry.value?.value;
          final unit = entry.metadata?.unit ?? '';
          print('  ${entry.path}: $value $unit');
        }
      },
      onError: (error) {
        print('✗ Subscription error: $error');
      },
      onDone: () {
        print('✓ Subscription completed');
      },
    );

    // Simulate setting values periodically
    print('\nSimulating value updates...\n');
    for (var i = 0; i < 10; i++) {
      await Future.delayed(Duration(seconds: 1));
      
      try {
        await client.setCurrentValues({
          'Vehicle.Speed': 100.0 + (i * 5),
          'Vehicle.Powertrain.Engine.Speed': 2000.0 + (i * 100),
        });
      } catch (e) {
        print('Error setting values: $e');
      }
    }

    // Clean up
    await subscription.cancel();
    print('\n✓ Subscription cancelled');
  } catch (e) {
    print('✗ Error: $e');
  } finally {
    await client.disconnect();
    print('✓ Disconnected');
  }
}
