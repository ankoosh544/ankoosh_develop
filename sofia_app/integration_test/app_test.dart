// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:sofia_app/main.dart' as app;
// import 'package:sofia_app/screens/home/home_screen.dart';
// import 'package:sofia_app/screens/login/login_screen.dart';
// import 'package:sofia_app/screens/registration/registration_screen.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   group(
//     "End to End Test",
//     () {
//       testWidgets(
//         'Registration Test ',
//         (registrationtester) async {
//           app.main();
//           // Simulate navigating to the RegistrationScreen
//           Navigator.of(registrationtester
//                   .element(find.text('Navigate to Registration')))
//               .push(MaterialPageRoute(
//             builder: (context) => RegistrationScreen(),
//           ));
//           await registrationtester.pumpAndSettle();
//           await Future.delayed(const Duration(seconds: 2));
//           await registrationtester.enterText(
//               find.byType(TextFormField).at(0), 'ankoosh.sk@gmail.com');
//           await Future.delayed(const Duration(seconds: 2));
//           await registrationtester.enterText(
//               find.byType(TextFormField).at(1), 'ankoos');
//           await Future.delayed(const Duration(seconds: 2));
//           await registrationtester.enterText(
//               find.byType(TextFormField).at(2), 'ankoos');
//           await Future.delayed(const Duration(seconds: 2));
//           await registrationtester.tap(find.byType(ElevatedButton).at(0));
//           await Future.delayed(const Duration(seconds: 2));
//           await registrationtester.pumpAndSettle();

//           expect(find.byType(LoginScreen), findsOneWidget);
//           await Future.delayed(const Duration(seconds: 2));
//         },
//       );

//       testWidgets(
//         'Verify LoginScreen with Correct Value',
//         (logintester) async {
//           app.main();
//           await logintester.pumpAndSettle();
//           await Future.delayed(const Duration(seconds: 2));
//           await logintester.enterText(find.byType(TextFormField).at(0), 'test');
//           await Future.delayed(const Duration(seconds: 2));
//           await logintester.enterText(find.byType(TextFormField).at(1), 'test');
//           await Future.delayed(const Duration(seconds: 2));
//           await logintester.tap(find.byType(ElevatedButton).at(0));
//           await Future.delayed(const Duration(seconds: 2));
//           await logintester.pumpAndSettle();

//           expect(find.byType(HomeScreen), findsOneWidget);
//           await Future.delayed(const Duration(seconds: 2));
//         },
//       );
//       testWidgets(
//         'Verify LoginScreen with Invalid Values',
//         (logintester) async {
//           app.main();
//           await logintester.pumpAndSettle();
//           await Future.delayed(const Duration(seconds: 2));
//           await logintester.enterText(find.byType(TextFormField).at(0), 'shek');
//           await Future.delayed(const Duration(seconds: 2));
//           await logintester.enterText(find.byType(TextFormField).at(1), 'shek');
//           await Future.delayed(const Duration(seconds: 2));
//           await logintester.tap(find.byType(ElevatedButton).at(0));
//           await Future.delayed(const Duration(seconds: 2));
//           await logintester.pumpAndSettle();

//           expect(find.text("Invalid username or password."), findsOneWidget);
//           await Future.delayed(const Duration(seconds: 10));
//         },
//       );
//     },
//   );
// }
