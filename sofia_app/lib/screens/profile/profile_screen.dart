import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofia_app/providers/profile_provider.dart';

import '../../configs/index.dart';
import '../../main.dart';
import '../../widgets/index.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SofiaAppBar(
        title: tabProfile,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64.0,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(logo),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              context.watch<ProfileProvider>().username,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const SizedBox(height: 16.0),
            ListTile(
              leading: const Icon(Icons.email),
              title:
                  Text(context.watch<ProfileProvider>().emailId ?? 'EmailId'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileProvider>().logout();
                // Navigate to the login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => launchLoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
