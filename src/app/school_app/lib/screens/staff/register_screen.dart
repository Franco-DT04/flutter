// lib/screens/staff/register_screen.dart
import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../../models/user.dart';
import '../../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Map<String, List<User>> classStudents = {};
  List<String> classNames = AppConstants.schoolClasses;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final db = DatabaseHelper();
    Map<String, List<User>> temp = {};
    for (final className in classNames) {
      final students = await db.getStudentsByClass(className);
      temp[className] = students;
    }
    setState(() {
      classStudents = temp;
    });
  }

  void _goToSignupChoice() {
    Navigator.pushNamed(context, AppConstants.signupChoiceRoute)
        .then((_) => _loadStudents()); // Refresh after returning
  }

  void _goToStudentStats(User student) {
    Navigator.pushNamed(
      context,
      AppConstants.staffStatsRoute,
      arguments: student,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Register'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add/Remove Account',
            onPressed: _goToSignupChoice,
          ),
        ],
      ),
      body: classStudents.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: classNames.map((className) {
                final students = classStudents[className] ?? [];
                return ExpansionTile(
                  title: Text(className),
                  children: students.isEmpty
                      ? [
                          const ListTile(
                            title: Text('No students in this class.'),
                          )
                        ]
                      : students.map((student) {
                          return ListTile(
                            title: Text(student.name),
                            subtitle: Text(student.email),
                            onTap: () => _goToStudentStats(student),
                          );
                        }).toList(),
                );
              }).toList(),
            ),
    );
  }
}