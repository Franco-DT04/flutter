// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/shared_prefs_helper.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPrefsHelper().getUserRole(),
      builder: (context, snapshot) {
        final isStaff = snapshot.data == 'staff';

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Northwood High',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              if (!isStaff) ...[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    AppConstants.studentHomeRoute,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    AppConstants.studentNotificationsRoute,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Statistics'),
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    AppConstants.studentStatsRoute,
                  ),
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Student Register'),
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    AppConstants.staffRegisterRoute,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.announcement),
                  title: const Text('Announcements'),
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    AppConstants.staffAnnouncementRoute,
                  ),
                ),
              ],
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await SharedPrefsHelper().clearUserSession();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppConstants.loginRoute,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}