import 'package:postgres/postgres.dart';

class DatabaseConnection {
  // Connection configuration
  late PostgreSQLConnection _connection;

  DatabaseConnection() {
    _connection = PostgreSQLConnection(
      'ep-square-sun-a1o79qbw.ap-southeast-1.aws.neon.tech', // Host
      5432, // Port
      'neondb', // Database name
      username: 'neondb_owner', // Username
      password: 'HftxPEXu6Q5T', // Password
      useSSL: true, // Use SSL as required
    );
  }

  Future<PostgreSQLConnection> getConnection() async {
    if (_connection.isClosed) {
      await _connection.open();
    }
    return _connection;
  }

  Future<void> insertUser(String name, String email, String password) async {
    final conn = await getConnection();
    await conn.query(
      'INSERT INTO users (name, email, password) VALUES (@name, @email, @password)',
      substitutionValues: {
        'name': name,
        'email': email,
        'password':
            password, // Make sure to hash the password before storing it
      },
    );
  }

  // Login method
  Future<bool> loginUser(String email, String password) async {
    final conn = await getConnection();
    // Query to check if a user exists with the provided email and password
    var result = await conn.query(
      'SELECT * FROM users WHERE email = @email AND password = @password',
      substitutionValues: {
        'email': email,
        'password': password, // In production, use hashed password comparison
      },
    );

    // Check if a record is returned
    if (result.isEmpty) {
      return false; // Invalid credentials
    } else {
      return true; // Valid credentials
    }
  }
}
