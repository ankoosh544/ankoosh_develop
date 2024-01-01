import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/providers/registration_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../configs/app_strings.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(logo),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                //errorText: context.read<RegistrationProvider>().emailError,
                hintText: AppLocalizations.of(context)!.email,
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.blueGrey,
                ),
              ),
              onChanged: (value) {
                context.read<RegistrationProvider>().setEmail(value);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                // errorText: context.read<RegistrationProvider>().usernameError,
                hintText: AppLocalizations.of(context)!.username,
                hintStyle: TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.blueGrey,
                ),
              ),
              onChanged: (value) {
                context.read<RegistrationProvider>().setUsername(value);
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              obscureText:
                  !context.watch<RegistrationProvider>().isPasswordVisible,
              style: TextStyle(color: Colors.blueGrey),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.password,
                hintStyle: TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.blueGrey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    context.read<RegistrationProvider>().isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    context
                        .read<RegistrationProvider>()
                        .toggleVisiblePassword();
                  },
                ),
              ),
              onChanged: (value) {
                context.read<RegistrationProvider>().setPassword(value);
              },
            ),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity, // Make the button full width
              child: ElevatedButton(
                onPressed: () async {
                  final result =
                      await context.read<RegistrationProvider>().registerUser();
                  if (context.mounted && result) {
                    buildShowDialog(
                      context,
                      title: 'Registration Successful',
                      content: 'Your registration was successful.',
                      result: result,
                    );
                  } else {
                    buildShowDialog(
                      context,
                      title: 'Error Occurred!!',
                      content: 'Please try again',
                      result: result,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blueGrey, // This sets the background color
                  foregroundColor:
                      Colors.white, // This sets the color of the text and icon
                  padding: EdgeInsets.symmetric(
                      vertical: 12), // This sets the padding inside the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // This sets the shape and border radius of the button
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowDialog(
    BuildContext context, {
    required String title,
    required String content,
    required bool result,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (result) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              } else {
                Navigator.pop(context);
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
