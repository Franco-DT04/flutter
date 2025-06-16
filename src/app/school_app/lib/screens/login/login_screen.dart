// lib/screens/login/login_screen.dart
import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../../models/user.dart';
import '../../services/shared_prefs_helper.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final db = DatabaseHelper();
      final user = await db.getUserByNameAndPassword(
        _nameController.text.trim(),
        _passwordController.text,
      );
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid name or password.')),
          );
        }
      } else {
        // Save session info
        await SharedPrefsHelper().saveUserSession(
          user.id!,
          user.role,
          user.name,
          user.email,
        );
        if (context.mounted) {
          if (user.role == 'student') {
            Navigator.pushReplacementNamed(context, AppConstants.studentHomeRoute);
          } else if (user.role == 'staff') {
            Navigator.pushReplacementNamed(context, AppConstants.staffRegisterRoute);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name and Surname',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 20),
              // Password
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your password' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ),
              // Optional: Sign Up link
              // const SizedBox(height: 16),
              // TextButton(
              //   onPressed: () {
              //     Navigator.pushNamed(context, AppConstants.signupChoiceRoute);
              //   },
              //   child: const Text('Don\'t have an account? Sign Up'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}