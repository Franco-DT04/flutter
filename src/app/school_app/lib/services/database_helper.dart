// lib/services/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'northwood_high.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        className TEXT
      )
    ''');

    // Create mood_entries table
    await db.execute('''
      CREATE TABLE mood_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        moodLevel INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Create announcements table
    await db.execute('''
      CREATE TABLE announcements(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        staffId INTEGER NOT NULL,
        FOREIGN KEY (staffId) REFERENCES users (id)
      )
    ''');

    // Insert premade staff account
    await db.insert('users', {
      'name': 'Admin Staff',
      'email': 'admin@northwood.edu',
      'password': 'admin123',
      'role': 'staff',
    });
  }

  // Add CRUD operations methods here as we implement the screens
    Future<void> prepopulateStudents() async {
    final db = await database;
    // Check if students already exist
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM users WHERE role = ?', ['student']),
    );
    if (count != null && count > 0) return;

    final classes = [
      'Class 9A', 'Class 9B', 'Class 9C',
      'Class 10A', 'Class 10B', 'Class 10C',
      'Class 11A', 'Class 11B', 'Class 11C',
      'Class 12A', 'Class 12B', 'Class 12C',
    ];

    final firstNames = [
      'Alex', 'Taylor', 'Jordan', 'Morgan', 'Casey', 'Riley', 'Jamie', 'Avery', 'Peyton', 'Quinn'
    ];
    final lastNames = [
      'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Garcia', 'Martinez', 'Lee'
    ];

    int studentNum = 1;
    for (final className in classes) {
      for (int i = 0; i < 10; i++) {
        final firstName = firstNames[i % firstNames.length];
        final lastName = lastNames[(i + studentNum) % lastNames.length];
        final name = '$firstName $lastName';
        final email = '${firstName.toLowerCase()}.${lastName.toLowerCase()}$studentNum@northwood.edu';
        await db.insert('users', {
          'name': name,
          'email': email,
          'password': 'NWH2025',
          'role': 'student',
          'className': className,
        });
        studentNum++;
      }
    }
  }

  Future<List<User>> getStudentsByClass(String className) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'role = ? AND className = ?',
      whereArgs: ['student', className],
      orderBy: 'name ASC',
    );
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort, // Prevent duplicate emails
    );
  }

  // Find user by name, email, and password
  Future<User?> getUserByCredentials(String name, String email, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'name = ? AND email = ? AND password = ?',
      whereArgs: [name, email, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Delete user by id
  Future<void> deleteUserById(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert a mood entry
  Future<void> insertMoodEntry(MoodEntry entry) async {
    final db = await database;
    await db.insert(
      'mood_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get mood entry for a specific date
  Future<MoodEntry?> getMoodEntryForDate(int userId, String date) async {
    final db = await database;
    final maps = await db.query(
      'mood_entries',
      where: 'userId = ? AND date LIKE ?',
      whereArgs: [userId, '$date%'],
    );
    if (maps.isNotEmpty) {
      return MoodEntry.fromMap(maps.first);
    }
    return null;
  }

  Future<List<MoodEntry>> getMoodEntriesForUserAndMonth(int userId, DateTime start, DateTime end) async {
    final db = await database;
    final maps = await db.query(
      'mood_entries',
      where: 'userId = ? AND date >= ? AND date <= ?',
      whereArgs: [
        userId,
        start.toIso8601String().substring(0, 10),
        end.toIso8601String().substring(0, 10),
      ],
      orderBy: 'date ASC',
    );
    return maps.map((map) => MoodEntry.fromMap(map)).toList();
  }

  // Insert an announcement
  Future<void> insertAnnouncement(Announcement announcement) async {
    final db = await database;
    await db.insert(
      'announcements',
      announcement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all announcements
  Future<List<Announcement>> getAllAnnouncements() async {
    final db = await database;
    final maps = await db.query(
      'announcements',
      orderBy: 'date DESC',
    );
    return maps.map((map) => Announcement.fromMap(map)).toList();
  }

  Future<User?> getUserByNameAndPassword(String name, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'name = ? AND password = ?',
      whereArgs: [name, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }


}

