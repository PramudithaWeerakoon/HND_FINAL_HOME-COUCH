import 'db_connection.dart'; 

class AuthProvider {
  final DatabaseConnection _dbConnection;
  String? _loggedInEmail;

  AuthProvider(this._dbConnection);

  // Register a user and return the email after successful registration
  Future<String?> registerUser(
      String name, String email, String password) async {
    try {
      await _dbConnection.insertUser(name, email, password);
      _loggedInEmail = email;
      return _loggedInEmail;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  // Login a user and return the email after successful login
  Future<String?> loginUser(String email, String password) async {
    bool success = await _dbConnection.loginUser(email, password);
    if (success) {
      _loggedInEmail = email;
      return _loggedInEmail;
    } else {
      return null;
    }
  }

  // Getter for logged-in email
  String? getLoggedInEmail() {
    return _loggedInEmail;
  }

  // Add a public getter for _dbConnection to access it from other classes
  DatabaseConnection get dbConnection => _dbConnection;
}
