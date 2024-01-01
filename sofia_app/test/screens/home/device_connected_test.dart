import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/configs/index.dart';
import 'package:sofia_app/providers/index.dart';
import 'package:sofia_app/screens/home/device_connected.dart';
import 'package:sofia_app/services/ble_service.dart';

void main() {
  const String userName = 'Test User Name';
  const String emailId = 'testing@gmail.com';

  late BleProvider bleProvider;
  late ProfileProvider profileProvider;

  setUp(() {
    bleProvider = BleProvider(BleImpl());
    profileProvider = ProfileProvider();
    profileProvider
      ..username = userName
      ..emailId = emailId;
  });

  MaterialApp materialApp() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ListenableProvider<BleProvider>(create: (_) => bleProvider),
          ListenableProvider<ProfileProvider>(create: (_) => profileProvider),
        ],
        child: const DeviceConnected(),
      ),
    );
  }

  group('Device Connected - UI Tests', () {
    testWidgets('Device Connected Screen - ', (tester) async {
      await tester.pumpWidget(materialApp());

      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(tabHome), findsOneWidget);
      expect(find.text('$welcomeMessage $userName'), findsOneWidget);
      expect(find.text(greetingMessage), findsOneWidget);
      expect(find.text(sourceFrom), findsOneWidget);
      expect(find.text(waitingForConnection), findsOneWidget);
      expect(find.text(sourceTo), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text(warningAttentionforLight), findsOneWidget);
      expect(find.text(warningAttentionForOutOfService), findsOneWidget);
    });

    // testWidgets('Device Connected Screen - Device connected', (tester) async {
    //   await tester.pumpWidget(materialApp());
    //   bleProvider.setConnectedDevice(
    //     BluetoothDevice(
    //       remoteId: const DeviceIdentifier('24:4C:AB:09:3F:82'),
    //       localName: 'Piano 1',
    //       type: BluetoothDeviceType.dual,
    //     ),
    //   );
    //
    //   await tester.pumpAndSettle();
    //   expect(find.text(waitingForConnection), findsNothing);
    //   // TODO expect to check 1 should show on UI only once but it showing 2 times, need to correct below statement.
    //   //expect(find.text('1'), findsNWidgets(2));
    // });
  });
}
