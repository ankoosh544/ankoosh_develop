import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/configs/app_strings.dart';
import 'package:sofia_app/providers/index.dart';
import 'package:sofia_app/screens/profile/profile_screen.dart';
import 'package:sofia_app/services/ble_service.dart';

void main() {
  const String userName = 'Test User Name';
  const String emailId = 'testing@gmail.com';

  MaterialApp materialApp() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ListenableProvider<BleProvider>(
            create: (_) => BleProvider(
              BleImpl(),
            ),
          ),
          ListenableProvider<ProfileProvider>(
            create: (_) => ProfileProvider()
              ..username = userName
              ..emailId = emailId,
          ),
        ],
        child: const ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen - ', () {
    testWidgets('ProfileScreen - ', (tester) async {
      await tester.pumpWidget(materialApp());

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(tabProfile), findsOneWidget);
      expect(find.image(const AssetImage(logo)), findsOneWidget);
      expect(find.text(userName), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.text(emailId), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
