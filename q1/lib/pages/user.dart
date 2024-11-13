// user.dart

class User {
  final int? id; // Nullable to allow the database to auto-increment the ID
  final String email;
  final String password; // Store hashed password only
  final int age;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.age,
  });

  // Convert User instance to a map for database insertion or updating
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'age': age,
    };
  }

  // Factory constructor to create a User from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      age: map['age'],
    );
  }
}
