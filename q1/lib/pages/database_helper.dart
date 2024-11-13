import 'dart:async';
import 'package:sqflite/sqflite.dart'; // Default sqflite package for Android
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart'; // Import bcrypt for password hashing

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton instance
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'login_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the user table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  // Register a new user if email doesn't already exist
  Future<int> registerUser(String email, String password) async {
    final db = await database;

    // Check if email already exists
    final List<Map<String, dynamic>> existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUser.isNotEmpty) {
      throw Exception("Email already registered.");
    }

    // Hash the password before saving to the database
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    return await db.insert(
      'users',
      {'email': email, 'password': hashedPassword},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // Login user by checking if email and password match an existing user
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
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
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Update user's password (if necessary)
  Future<int> updateUserPassword(String email, String newPassword) async {
    final db = await database;
    String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

    return await db.update(
      'users',
      {'password': hashedPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Delete all users (useful for testing or reset)
  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }
}
