import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/providers/ble_provider.dart';
import 'package:sofia_app/providers/forgot_password_provider.dart';
import 'package:sofia_app/providers/registration_provider.dart';
import 'package:sofia_app/screens/car_status/car_status_screen.dart';
import 'package:sofia_app/screens/login/login_screen.dart';
import 'package:sofia_app/screens/registration/registration_screen.dart';
import 'database/app_database.dart';
import 'providers/login_provider.dart';
import 'screens/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SofiaDatabase.initDatabase();
  if (Platform.isAndroid) {
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request().then((status) {
      _launchApp();
    });
  } else {
    _launchApp();
  }
}

void _launchApp() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BleProvider(BleImpl())),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
      ],
      child: const SofiaApp(),
    ),
  );
}

class SofiaApp extends StatefulWidget {
  const SofiaApp({Key? key}) : super(key: key);

  @override
  State<SofiaApp> createState() => _SofiaAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _SofiaAppState? state = context.findAncestorStateOfType<_SofiaAppState>();
    state?.setLocale(newLocale);
  }
}

class _SofiaAppState extends State<SofiaApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BleProvider(BleImpl()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
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
        locale: _locale,
        routes: {
          '/': (context) => launchLoginScreen(),
          '/register': (context) => launchRegistrationScreen(),
          '/home': (context) => _launchHomeScreen(),
          '/car': (context) => _launchCarStatusScreen(),
        },
      ),
    );
  }
}

ChangeNotifierProvider<LoginProvider> launchLoginScreen() =>
    ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const LoginScreen(),
    );

ChangeNotifierProvider<RegistrationProvider> launchRegistrationScreen() =>
    ChangeNotifierProvider(
      create: (_) => RegistrationProvider(),
      child: const RegistrationScreen(),
    );

HomeScreen _launchHomeScreen() => const HomeScreen();

CarStatusScreen _launchCarStatusScreen() => const CarStatusScreen();
