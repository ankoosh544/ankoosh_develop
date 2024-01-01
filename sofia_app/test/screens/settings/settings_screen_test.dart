import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/configs/app_strings.dart';
import 'package:sofia_app/providers/index.dart';
import 'package:sofia_app/screens/settings/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sofia_app/services/ble_service.dart';

void main() {
  MaterialApp materialApp() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('it'), // Italian
        Locale('es'), // Spanish
      ],
      locale: const Locale('en'),
      home: MultiProvider(
        providers: [
          ListenableProvider<BleProvider>(
            create: (_) => BleProvider(BleImpl()),
          ),
          ListenableProvider<SettingsProvider>(
              create: (_) => SettingsProvider()),
        ],
        child: const SettingsScreen(),
      ),
    );
  }

  group('SettingsScreen - UI Tests', () {
    testWidgets('SettingsScreen User Interface Testing- ', (tester) async {
      await tester.pumpWidget(materialApp());

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(tabSettings), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);

      expect(find.text('Messages from SmartPhones'), findsOneWidget);
      expect(find.text('Audio'), findsOneWidget);
      expect(find.text('Visual'), findsOneWidget);
      expect(find.byType(RadioListTile<String>), findsNWidgets(2));

      expect(find.text('Command to SmartPhones'), findsOneWidget);
      expect(find.text('Screen touch'), findsOneWidget);
      expect(find.text('Speach'), findsOneWidget);

      expect(find.text('Priority'), findsOneWidget);
      expect(find.text('President'), findsOneWidget);
      expect(find.text('Disable People'), findsOneWidget);

      expect(find.byType(Switch), findsNWidgets(4));
    });
  });
}
