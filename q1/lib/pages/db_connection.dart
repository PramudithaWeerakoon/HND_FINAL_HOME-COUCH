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

  // Open database connection
  Future<void> openConnection() async {
    try {
      print('Attempting to connect to the database...');
      await _connection.open();
      print('Connected to the database successfully!');

      // Example query
      var result = await _connection.query('SELECT NOW()');
      print('Current Database Time: ${result[0][0]}');
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  // Close database connection
  Future<void> closeConnection() async {
    try {
      await _connection.close();
      print('Database connection closed.');
    } catch (e) {
      print('Failed to close the database: $e');
    }
  }
}
