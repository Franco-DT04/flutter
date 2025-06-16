// lib/screens/signup/signup_choice_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class SignupChoiceScreen extends StatelessWidget {
  const SignupChoiceScreen({super.key});

  void _navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Top image (replace with your asset or network image as needed)
            SizedBox(
              height: 180,
              child: Image.asset(
                'assets/signup_choice.png', // Place your image in assets and update pubspec.yaml
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            // Buttons
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Staff', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => _navigate(context, AppConstants.signupStaffRoute),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.school),
              label: const Text('Learner', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => _navigate(context, AppConstants.signupStudentRoute),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.remove_circle),
              label: const Text('Remove', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => _navigate(context, AppConstants.signupRemoveRoute),
            ),
          ],
        ),
      ),
    );
  }
}