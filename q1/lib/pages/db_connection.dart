import 'package:postgres/postgres.dart';
import 'package:intl/intl.dart';
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
      'ep-damp-glitter-a1pn9kcw.ap-southeast-1.aws.neon.tech', // Host
      5432, // Port
      'neondb', // Database name
      username: 'neondb_owner', // Username
      password: 'pigA2fI1kHCP', // Password
      useSSL: true, // Use SSL as required
    );
  }

  // Method to get the database connection with timeout handling
  Future<PostgreSQLConnection> getConnection() async {
    try {
      if (_connection.isClosed) {
        await _connection.open();
        print("Database connected to HomercouchFinal");
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
      'INSERT INTO users (username, useremail, userpassword) VALUES (@name, @email, @password)',
      substitutionValues: {
        'name': name,
        'email': email,
        'password': password, // Hash the password before storing in production
      },
    );

    // Save the email to SessionManager
    SessionManager.setUserEmail(email);
  }

  Future<bool> loginUsergoogle(String email) async {
    final conn = await getConnection(); // Get the database connection

    // Check if the user exists in the database
    final result = await conn.query(
      "SELECT COUNT(*) FROM users WHERE useremail = @email",
      substitutionValues: {
        'email': email, // Pass email as substitution value
      },
    );

    // If count > 0, the user exists
    return result.isNotEmpty && result.first[0] > 0;
    // Save the email to SessionManager
    SessionManager.setUserEmail(email);
  }

   // Check if a user exists in the database by email
  Future<bool> isUserExistsgoogle(String email) async {
    const query = "SELECT COUNT(*) FROM users WHERE useremail = @Email";
    final result = await _connection.query(query, substitutionValues: {
      'Email': email,
    });

    final count = result.first[0];
    return count > 0;
  }

  // Execute a raw query
  Future<List<Map<String, dynamic>>> executeRawQuery(
      String query, List<dynamic> parameters) async {
    final result =
        await _connection.mappedResultsQuery(query, substitutionValues: {
      for (var i = 0; i < parameters.length; i++) 'p$i': parameters[i],
    });

    return result;
  }


  Future<bool> userExists(String email) async {
  final conn = await getConnection();
  try {
    final result = await conn.query(
      '''
      SELECT COUNT(*) FROM users WHERE useremail = @userEmail
      ''',
      substitutionValues: {'userEmail': email},
    );

    return result.isNotEmpty && result.first[0] > 0; // Check if count > 0
  } catch (e) {
    print("Error checking if user exists: $e");
    return false; // In case of an error, assume user does not exist
  }
  SessionManager.setUserEmail(email);
}


 // Insert or update AuthProvider details
  Future<void> insertOrUpdateAuthProvider(
    String authType,
    String userEmail,
    String? accessToken,
    String? refreshToken,
    String? authUrl,
    String tokenExpiry,
  ) async {
    final conn = await getConnection();

    // Set refreshToken to the current time if it's null
    refreshToken ??= DateTime.now().toIso8601String(); // Use the current time

    try {
      await conn.query(
        '''
      INSERT INTO AuthProvider (
        AP_Type, AP_UserID, AP_AccessToken, AP_RefreshToken, AP_URL, AP_TokenExpiry, AP_CreatedAt, AP_UpdatedAt
      ) VALUES (
        @authType, @userEmail, @accessToken, @refreshToken, @authUrl, @tokenExpiry, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      )
      ON CONFLICT (AP_UserID, AP_Type) 
      DO UPDATE SET 
        AP_AccessToken = EXCLUDED.AP_AccessToken,
        AP_RefreshToken = EXCLUDED.AP_RefreshToken,
        AP_URL = EXCLUDED.AP_URL,
        AP_TokenExpiry = EXCLUDED.AP_TokenExpiry,
        AP_UpdatedAt = CURRENT_TIMESTAMP;
      ''',
        substitutionValues: {
          'authType': authType,
          'userEmail': userEmail,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'authUrl': authUrl,
          'tokenExpiry': tokenExpiry,
        },
      );
      print("AuthProvider details inserted/updated successfully.");
    } catch (e) {
      print("Error inserting/updating AuthProvider: $e");
      rethrow;
    }
  }



  // Method to update the user's age based on the email
  Future<void> updateAge(int age) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE fitnessprofile SET fp_age = @age WHERE fp_userid = @email',
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
      'SELECT * FROM Users WHERE userEmail = @email AND  userPassword = @password',
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

    // Get the current timestamp
    final currentTimestamp = DateTime.now().toIso8601String();

    await conn.query(
      '''
    INSERT INTO WeightHistory (WH_RecordedAt, WH_Weight, WH_UserID)
    VALUES (@recorded_at, @body_weight, @user_email)
    ''',
      substitutionValues: {
        'recorded_at': currentTimestamp,
        'user_email': email,
        'body_weight': bodyWeight,
      },
    );
    print("Body weight updated successfully for $email at $currentTimestamp.");
  }

  // Method to update the user's height and maintain history
  Future<void> updateHeight(double height, bool isFeetSelected) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    // Convert height to meters only if it's in feet
    double heightInMeters = isFeetSelected ? height * 0.3048 : height;

    // Get the current timestamp
    final currentTimestamp = DateTime.now().toIso8601String();

    await conn.query(
      '''
    INSERT INTO HeightHistory (HH_RecordedAt, HH_Height, HH_UserID)
    VALUES (@recorded_at, @height, @user_email)
    ''',
      substitutionValues: {
        'recorded_at': currentTimestamp,
        'user_email': email,
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
      'UPDATE FitnessProfile SET fp_bodyType = @bodyType WHERE FP_UserID = @userEmail',
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
      'UPDATE FitnessProfile SET FP_FitnessBackground = @fitnessBackground WHERE FP_UserID = @email',
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
      'UPDATE FitnessProfile SET FP_WaistCircumference = @waistCircumference WHERE FP_UserID = @email',
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
      'UPDATE FitnessProfile SET FP_NeckCircumference = @neckCircumference WHERE FP_UserID = @email',
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

  // Method to get the current user's email
  Future<String> getUserEmail() async {
    final email =
        SessionManager.getUserEmail(); // Retrieve email from SessionManager

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    return email;
  }

  Future<void> logout() async {
    try {
      // Clear session data (example: clear user email)
      SessionManager.clearSession(); // Implement this method in your session manager
      print("User logged out successfully.");
    } catch (e) {
      print("Error during logout: $e");
    }
  }

   // New method to get user data (name, email, and password) of the current logged-in user
  Future<Map<String, dynamic>?> getUserData() async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    var result = await conn.query(
      'SELECT name, email, password FROM users WHERE email = @email',
      substitutionValues: {
        'email': email,
      },
    );

    if (result.isNotEmpty) {
      return {
        'name': result.first[0],
        'email': result.first[1],
        'password': result.first[2],
      };
    }

    return null; // Return null if no user is found
  }


  // Method to update the user's name, email, and password based on the email
  Future<void> updateUserInfo(
      {String? name, String? email, String? password}) async {
    final conn = await getConnection();
    final currentEmail = SessionManager.getUserEmail();

    if (currentEmail == null) {
      throw Exception("No user is currently logged in.");
    }

    // Prepare SQL update query
    String updateQuery = 'UPDATE users SET ';
    Map<String, dynamic> substitutionValues = {};

    if (name != null) {
      updateQuery += 'name = @name, ';
      substitutionValues['name'] = name;
    }
    if (email != null) {
      updateQuery += 'email = @email, ';
      substitutionValues['email'] = email;
    }
    if (password != null) {
      updateQuery += 'password = @password, ';
      substitutionValues['password'] = password;
    }

    // Remove the last comma and space
    updateQuery = updateQuery.substring(0, updateQuery.length - 2);

    // Add the condition to update by email
    updateQuery += ' WHERE email = @currentEmail';
    substitutionValues['currentEmail'] = currentEmail;

    // Execute the update query
    await conn.query(
      updateQuery,
      substitutionValues: substitutionValues,
    );
    print("User info updated successfully for $currentEmail.");
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


