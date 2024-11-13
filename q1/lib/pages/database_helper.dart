import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Ensure using sqflite_common_ffi for desktop
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart'; // Import bcrypt for password hashing

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton instance
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Initialize database factory to sqflite_common_ffi (for desktop platforms)
  Future<void> init() async {
    // Ensure that the databaseFactory is set to the FFI implementation for desktop
    databaseFactory = databaseFactoryFfi;
  }

  // Lazily load the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    await init(); // Ensure the factory is initialized before opening the database
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database (creating or opening the existing database)
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'login_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate:
          _onCreate, // Create the tables when the database is first created
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

    // Check if email already exists in the database
    final List<Map<String, dynamic>> existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUser.isNotEmpty) {
      throw Exception("Email already registered.");
    }

    // Hash the password before saving it to the database
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    // Insert the new user into the 'users' table
    return await db.insert(
      'users',
      {'email': email, 'password': hashedPassword},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // Login user by checking if email and password match an existing user
  Future<bool> loginUser(String email, String password) async {
    final db = await database;

    // Query the database for the user with the given email
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) {
      return false; // Email not found
    }

    // Get the stored hashed password from the result
    String storedHashedPassword = result.first['password'] as String;

    // Verify if the provided password matches the stored hashed password
    return BCrypt.checkpw(password, storedHashedPassword);
  }

  // Helper function to check if an email is already registered
  Future<bool> isEmailRegistered(String email) async {
    final db = await database;

    // Query the database to check if the email exists
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty; // Return true if email is found
  }

  // Update the user's password (useful for password change functionality)
  Future<int> updateUserPassword(String email, String newPassword) async {
    final db = await database;

    // Hash the new password before saving it to the database
    String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

    // Update the user's password in the database
    return await db.update(
      'users',
      {'password': hashedPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Delete all users (useful for testing or resetting the database)
  Future<void> deleteAllUsers() async {
    final db = await database;

    // Delete all records from the 'users' table
    await db.delete('users');
  }
}
