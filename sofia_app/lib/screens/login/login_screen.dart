import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/main.dart';

import 'package:sofia_app/providers/login_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../password/forgot_password_screen.dart';
import '../../configs/app_strings.dart';
import 'package:sofia_app/storage/local_store.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(logo),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.blueGrey),
                    decoration: InputDecoration(
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
                      context.read<LoginProvider>().setUsername(value);
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    obscureText:
                        !context.watch<LoginProvider>().isPasswordVisible,
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
                          context.read<LoginProvider>().isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          context.read<LoginProvider>().toggleVisiblePassword();
                        },
                      ),
                    ),
                    onChanged: (value) {
                      context.read<LoginProvider>().setPassword(value);
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: context.read<LoginProvider>().rememberMe,
                        onChanged: (value) {
                          context
                              .read<LoginProvider>()
                              .toggleRememberMe(value!);
                          if (value) {
                            var username =
                                context.read<LoginProvider>().username;
                            var password =
                                context.read<LoginProvider>().password;
                            LocalStore.setValue(
                                key: 'username', value: username);
                            LocalStore.setValue(
                                key: 'password', value: password);
                          } else {
                            LocalStore.delete(key: 'username');
                            LocalStore.delete(key: 'password');
                          }
                        },
                      ),
                      const Text(
                        'Remember Me',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          forgotPassword(context);
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result =
                            await context.read<LoginProvider>().login();
                        if (context.mounted) {
                          if (result) {
                            await Navigator.pushReplacementNamed(
                                context, '/home');
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Login Failed'),
                                content: Text('Invalid username or password.'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Login'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      registerUser(context);

                      // Replace with the appropriate function or route to navigate to the registration screen
                      // Example using named route: Navigator.pushNamed(context, '/registration');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueGrey,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('New User? Register Here'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Powered by McAllinn Italian SRL',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void forgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  void registerUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => launchRegistrationScreen(),
      ),
    );
  }
}
