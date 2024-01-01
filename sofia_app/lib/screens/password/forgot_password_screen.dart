import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sofia_app/providers/forgot_password_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String enteredEmail = '';
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Forgot Password Screen',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.blueGrey),
                decoration: InputDecoration(
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
                  enteredEmail = value;
                  context.read<ForgotPasswordProvider>().setEmail(value);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final email =
                      enteredEmail; // get the entered email from the TextFormField
                  final password = await context
                      .read<ForgotPasswordProvider>()
                      .fetchPasswordFromDatabase(email);

                  final Email emailMessage = Email(
                    body: 'Your password is: $password',
                    subject: 'Password Recovery',
                    recipients: [email],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(emailMessage);
                },
                child: Text(
                  'Send',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
