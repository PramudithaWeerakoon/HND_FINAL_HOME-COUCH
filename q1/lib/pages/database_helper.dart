import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';
import 'user.dart'; // Import the User model

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton instance
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Helper function to normalize email
  String normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database with an upgraded version to include the gender column
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'login_database.db');
    return await openDatabase(
      path,
      version: 3, // Incremented database version for migration
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add onUpgrade for migrations
    );
  }

  // Initial table creation with age and gender column
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        age INTEGER DEFAULT 0,
        gender TEXT
      )
    ''');
  }

  // Migration to add the gender column if upgrading from version 2 to 3
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE users ADD COLUMN gender TEXT');
    }
  }

  // Register a new user
  Future<int> registerUser(String email, String password) async {
    final db = await database;

    // Normalize email before checking
    String normalizedEmail = normalizeEmail(email);

    // Check if email already exists
    final List<Map<String, dynamic>> existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );

    if (existingUser.isNotEmpty) {
      throw Exception("Email already registered.");
    }

    // Hash the password before saving to the database
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    // Print user registration info
    print("Registering user: $normalizedEmail");

    return await db.insert(
      'users',
      {
        'email': normalizedEmail,
        'password': hashedPassword,
        'age': 0,
        'gender': null
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // Login user by checking if email and password match an existing user
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    String normalizedEmail = normalizeEmail(email); // Normalize email

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );

    if (result.isEmpty) {
      return false; // Email not found
    }

    // Get stored hashed password
    String storedHashedPassword = result.first['password'] as String;

    // Verify the provided password matches the stored hashed password
    return BCrypt.checkpw(password, storedHashedPassword);
  }

  // Helper function to check if an email is already registered
  Future<bool> isEmailRegistered(String email) async {
    final db = await database;
    String normalizedEmail = normalizeEmail(email); // Normalize email

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );
    return result.isNotEmpty;
  }

  // Update the user's age by email
  Future<void> updateUserAge(String email, int age) async {
    final db = await database;
    String normalizedEmail = normalizeEmail(email); // Normalize email

    await db.update(
      'users',
      {'age': age},
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );
  }

  // Update user's password
  Future<int> updateUserPassword(String email, String newPassword) async {
    final db = await database;
    String normalizedEmail = normalizeEmail(email); // Normalize email
    String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

    return await db.update(
      'users',
      {'password': hashedPassword},
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );
  }

  // Delete all users (useful for testing or reset)
  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }

  // Retrieve a user's age by email
  Future<int?> getUserAge(String email) async {
    final db = await database;
    String normalizedEmail = normalizeEmail(email); // Normalize email

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['age'],
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );

    if (result.isNotEmpty) {
      return result.first['age'] as int?;
    }
    return null;
  }

  // Retrieve a User by email (useful for retrieving all user information)
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    String normalizedEmail = normalizeEmail(email); // Normalize email

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Print all user information (for debugging purposes)
  Future<void> printUserInfo(String email) async {
    final db = await database;
    String normalizedEmail = normalizeEmail(email); // Normalize email

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );

    if (result.isNotEmpty) {
      print("User Information:");
      print("ID: ${result.first['id']}");
      print("Email: ${result.first['email']}");
      print("Age: ${result.first['age']}");
      print("Gender: ${result.first['gender']}");
    } else {
      print("User not found.");
    }
  }

  // Method to save the gender in the database
  Future<void> saveUserGender(String email, String gender) async {
    final db = await database;

    // Normalize the email before saving
    String normalizedEmail = normalizeEmail(email);

    // Update the user's gender in the 'users' table
    await db.update(
      'users',
      {'gender': gender},
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );
  }

  // Method to fetch the saved gender (if needed)
  Future<String?> getUserGender(String email) async {
    final db = await database;
    String normalizedEmail = normalizeEmail(email); // Normalize email

    final result = await db.query(
      'users',
      columns: ['gender'],
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );

    if (result.isNotEmpty) {
      return result.first['gender'] as String;
    }
    return null;
  }
}
