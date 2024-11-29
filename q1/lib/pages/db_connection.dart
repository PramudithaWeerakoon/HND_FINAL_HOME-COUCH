import 'package:postgres/postgres.dart';
import 'dart:math';



// SessionManager to manage the current user's session
class SessionManager {
  static String? currentUserEmail;

  // Set the current user's email
  static void setUserEmail(String email) {
    currentUserEmail = email;
  }

  // Get the current user's email
  static String? getUserEmail() {
    return currentUserEmail;
  }

  // Clear the session (e.g., on logout)
  static void clearSession() {
    currentUserEmail = null;
  }
}

class DatabaseConnection {
  // Connection configuration
  late PostgreSQLConnection _connection;

  // Constructor to initialize the connection
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

  // Method to get the database connection with timeout handling
  Future<PostgreSQLConnection> getConnection() async {
    try {
      if (_connection.isClosed) {
        await _connection.open();
      }
      return _connection;
    } catch (e) {
      if (e is PostgreSQLException) {
        print("Database connection error: ${e.message}");
      } else {
        print("Unexpected error: $e");
      }
      rethrow;
    }
  }

  

  // Method to insert a user into the database
  Future<void> insertUser(String name, String email, String password) async {
    final conn = await getConnection();
    await conn.query(
      'INSERT INTO users (name, email, password) VALUES (@name, @email, @password)',
      substitutionValues: {
        'name': name,
        'email': email,
        'password': password, // Hash the password before storing in production
      },
    );

    // Save the email to SessionManager
    SessionManager.setUserEmail(email);
  }

  // Method to update the user's age based on the email
  Future<void> updateAge(int age) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET age = @age WHERE email = @email',
      substitutionValues: {
        'email': email,
        'age': age,
      },
    );
  }

  // Login method
  Future<bool> loginUser(String email, String password) async {
    final conn = await getConnection();
    var result = await conn.query(
      'SELECT * FROM users WHERE email = @email AND password = @password',
      substitutionValues: {
        'email': email,
        'password': password, // Use hashed password comparison in production
      },
    );

    if (result.isNotEmpty) {
      // Save the email to SessionManager
      SessionManager.setUserEmail(email);
      return true;
    }
    return false;
  }

    // Method to update the user's body weight based on the email
  Future<void> updateBodyWeight(double bodyWeight) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET body_weight = @body_weight WHERE email = @email',
      substitutionValues: {
        'email': email,
        'body_weight': bodyWeight,
      },
    );
    print("Body weight updated successfully for $email.");
  }

  // Method to update the user's height based on the email
  Future<void> updateHeight(double height, bool isFeetSelected) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    // Convert height to meters only if it's in feet
    double heightInMeters = isFeetSelected ? height * 0.3048 : height;

    await conn.query(
      'UPDATE users SET body_height = @height WHERE email = @email',
      substitutionValues: {
        'email': email,
        'height': heightInMeters
            .toStringAsFixed(2), // Store height up to 2 decimal places
      },
    );
    print("Height updated successfully for $email.");
  }

   // Method to update the user's body type based on the email
  Future<void> updateBodyType(String bodyType) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET body_type = @bodyType WHERE email = @userEmail',
      substitutionValues: {
        'bodyType': bodyType,
        'userEmail': email,
      },
    );
    print("Body type updated successfully for $email.");
  }

   // Method to update the user's fitness background based on the email
  Future<void> updateFitnessBackground(String fitnessBackground) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET fitness_background = @fitnessBackground WHERE email = @email',
      substitutionValues: {
        'email': email,
        'fitnessBackground': fitnessBackground,
      },
    );
    print("Fitness background updated successfully for $email.");
  }

  // Method to update the user's waist circumference based on the email
  Future<void> saveWaistCircumferenceToDB(double waistCircumference) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET waist_circumference = @waistCircumference WHERE email = @email',
      substitutionValues: {
        'email': email,
        'waistCircumference': waistCircumference,
      },
    );
    print("Waist circumference updated successfully for $email.");
  }

    // Method to update the user's neck circumference based on the email
  Future<void> saveNeckCircumferenceToDB(double neckCircumference) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET neck_circumference = @neckCircumference WHERE email = @email',
      substitutionValues: {
        'email': email,
        'neckCircumference': neckCircumference,
      },
    );
    print("Neck circumference updated successfully for $email.");
  }


  // Method to update the user's medical condition based on the email
  Future<void> updateMedicalCondition(String medicalCondition) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET medical_conditions = @medicalCondition WHERE email = @email',
      substitutionValues: {
        'email': email,
        'medicalCondition': medicalCondition,
      },
    );
    print("Medical condition updated successfully for $email.");
  }


  


  Future<void> updateInjuryData(String injuryData) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    // Convert the injuryData string to a valid PostgreSQL array literal
    String formattedInjuryData =
        injuryData == 'None' ? '{}' : '{${injuryData.replaceAll(', ', ',')}}';

    await conn.query(
      'UPDATE users SET injuries = @injuries WHERE email = @email',
      substitutionValues: {
        'email': email,
        'injuries': formattedInjuryData,
      },
    );
    print("Injury data updated successfully for $email.");
  }




   // Method to calculate BMI
  double calculateBMI(double weight, double heightInMeters) {
    return weight / (heightInMeters * heightInMeters);
  }

  // Method to calculate Body Fat Percentage (U.S. Navy method)
  double calculateBodyFat(double waist, double neck, double height,
      {String gender = "male"}) {
    double bodyFat;
    if (gender.toLowerCase() == "male") {
      bodyFat = 86.010 * log(waist - neck) / log(10) -
          70.041 * log(height) / log(10) +
          36.76;
    } else {
      bodyFat = 163.205 * log(waist + 10 - neck) / log(10) -
          97.684 * log(height) / log(10) -
          78.387;
    }
    return bodyFat;
  }

  // Method to calculate Daily Caloric Intake using Mifflin-St Jeor equation
  double calculateDailyCalories(double weight, double height, int age,
      String gender, double activityLevel) {
    double bmr;
    if (gender.toLowerCase() == "male") {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    // Activity level multiplier
    double tdee = bmr * activityLevel;
    return tdee;
  }

  // Method to save BMI, body fat percentage, and daily caloric intake to the database
  Future<void> updateHealthData(
      double bmi, double bodyFat, double dailyCalories) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET bmi = @bmi, body_fat_percentage = @bodyFat, daily_caloric_intake = @dailyCalories WHERE email = @email',
      substitutionValues: {
        'email': email,
        'bmi': bmi,
        'bodyFat': bodyFat,
        'dailyCalories': dailyCalories,
      },
    );
    print("Health data updated successfully for $email.");
  }

 Future<Map<String, dynamic>> fetchHealthData() async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    var result = await conn.query(
      'SELECT body_weight, body_height, waist_circumference, neck_circumference, age, gender FROM users WHERE email = @email',
      substitutionValues: {'email': email},
    );

    if (result.isNotEmpty) {
      var row = result.first;

      double weight = row[0];
      double heightInMeters = row[1];
      double waistCircumference = row[2];
      double neckCircumference = row[3];
      int age = row[4];
      String gender = row[5];

      // Calculate BMI
      double bmi = calculateBMI(weight, heightInMeters);

      // Calculate body fat (assumed gender-specific)
      double bodyFat = calculateBodyFat(
          waistCircumference, neckCircumference, heightInMeters,
          gender: gender);

      // Calculate daily caloric intake (Assume a moderate activity level for this example)
      double dailyCalories = calculateDailyCalories(
          weight, heightInMeters * 100, age, gender, 1.55);

      return {
        'bmi': bmi,
        'bodyFat': bodyFat,
        'dailyCalories': dailyCalories,
        'weight': weight,
        'heightInMeters': heightInMeters,
      };
    } else {
      throw Exception("User not found.");
    }
  }

  // Method to get the user's name based on the current email
  Future<String> getUserName() async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    final result = await conn.query(
      'SELECT name FROM users WHERE email = @email',
      substitutionValues: {
        'email': email,
      },
    );

    if (result.isNotEmpty) {
      return result.first[0] as String;
    } else {
      throw Exception("User not found.");
    }
  }


  // Logout method
  void logout() {
    SessionManager.clearSession();
    print("User logged out successfully.");
    // Add any additional logout logic if required
  }

   // Method to update the user's gender based on the email
  Future<void> updateGender(String gender) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE users SET gender = @gender WHERE email = @email',
      substitutionValues: {
        'email': email,
        'gender': gender,
      },
    );
  }
}


