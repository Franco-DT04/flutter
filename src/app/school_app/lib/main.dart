// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login/login_screen.dart';
import 'services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DatabaseHelper().prepopulateStudents(); // <-- Call this before runApp
  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const NorthwoodHighApp());
}

class NorthwoodHighApp extends StatelessWidget {
  const NorthwoodHighApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Northwood High',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // You can customize these colors based on your school's theme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        // Add custom font if needed
        fontFamily: 'Roboto',
        
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),

        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      
      // Routes for navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/student/home': (context) => const HomeScreen(),
        '/student/notifications': (context) => const NotificationScreen(),
        '/student/stats': (context) => const StatsScreen(),
        '/staff/register': (context) => const RegisterScreen(),
        '/staff/announcement': (context) => const AnnouncementScreen(),
        '/staff/stats': (context) => const StaffStatsScreen(),
        '/signup/choice': (context) => const SignupChoiceScreen(),
        '/signup/student': (context) => const SignupStudentScreen(),
        '/signup/staff': (context) => const SignupStaffScreen(),
        '/signup/remove': (context) => const SignupRemoveScreen(),
      },
    );
  }
}

