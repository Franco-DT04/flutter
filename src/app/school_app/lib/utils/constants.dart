// Let's also create a simple constants file for reuse across the app
// lib/utils/constants.dart
class AppConstants {
  // Routes
  static const String loginRoute = '/';
  static const String studentHomeRoute = '/student/home';
  static const String studentNotificationsRoute = '/student/notifications';
  static const String studentStatsRoute = '/student/stats';
  static const String staffRegisterRoute = '/staff/register';
  static const String staffAnnouncementRoute = '/staff/announcement';
  static const String staffStatsRoute = '/staff/stats';
  static const String signupChoiceRoute = '/signup/choice';
  static const String signupStudentRoute = '/signup/student';
  static const String signupStaffRoute = '/signup/staff';
  static const String signupRemoveRoute = '/signup/remove';

  // Shared Preferences Keys
  static const String userIdKey = 'userId';
  static const String userRoleKey = 'userRole';
  static const String userNameKey = 'userName';
  static const String userEmailKey = 'userEmail';
  static const String isLoggedInKey = 'isLoggedIn';

  // Other Constants
  static const List<String> moodLevels = [
    'Very Low',
    'Low',
    'Neutral',
    'Good',
    'Excellent'
  ];

  static const List<String> schoolClasses = [
    'Class 9A', 'Class 9B', 'Class 9C',
    'Class 10A', 'Class 10B', 'Class 10C',
    'Class 11A', 'Class 11B', 'Class 11C',
    'Class 12A', 'Class 12B', 'Class 12C',
  ];
}
