import 'package:postgres/postgres.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:convert';


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
  
Future<void> upsertAge(int age) async {
    final conn = await getConnection();

    try {
      final email = SessionManager.getUserEmail();

      if (email == null) {
        throw Exception("No user is currently logged in.");
      }

      final result = await conn.query(
        '''
      INSERT INTO fitnessprofile (fp_userid, fp_age)
      VALUES (@email, @age)
      ON CONFLICT (fp_userid)
      DO UPDATE SET fp_age = EXCLUDED.fp_age
      ''',
        substitutionValues: {
          'email': email,
          'age': age,
        },
      );

      if (result.affectedRowCount == 0) {
        throw Exception("Failed to insert or update the record.");
      }
    } on PostgreSQLException catch (e) {
      throw Exception("Database error occurred: ${e.message}");
    } on Exception catch (e) {
      throw Exception("An error occurred: ${e.toString()}");
    }
  }

  // Method to update the user's gender based on the email
  Future<void> updateGender(String gender) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      'UPDATE FitnessProfile SET FP_Gender = @gender WHERE FP_UserID = @email',
      substitutionValues: {
        'email': email,
        'gender': gender,
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

  
    await conn.query(
      '''
      INSERT INTO FitnessProfile (FP_CurrentWeight, FP_UserID)
      VALUES (@body_weight, @user_email)
      ON CONFLICT (FP_UserID) DO UPDATE 
      SET FP_CurrentWeight = EXCLUDED.FP_CurrentWeight
      ''',
    substitutionValues: {
    'user_email': email,
    'body_weight': bodyWeight,
    },
  );

    print("Body weight updated successfully for $email.");
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

    

    await conn.query(
    '''
      INSERT INTO FitnessProfile (FP_CurrentHeight, FP_UserID)
      VALUES (@height, @user_email)
      ON CONFLICT (FP_UserID) DO UPDATE 
      SET FP_CurrentHeight = EXCLUDED.FP_CurrentHeight
      ''',
      substitutionValues: {
        'user_email': email,
        'height': heightInMeters.toStringAsFixed(2), // Store height up to 2 decimal places
      },
    );
    print("Height updated successfully for $email.");
  }


   Future<void> upsertBodyType(String bodyType) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    await conn.query(
      '''
    INSERT INTO FitnessProfile (FP_UserID, fp_bodyType)
    VALUES (@userEmail, @bodyType)
    ON CONFLICT (FP_UserID)
    DO UPDATE SET fp_bodyType = EXCLUDED.fp_bodyType
    ''',
      substitutionValues: {
        'bodyType': bodyType,
        'userEmail': email,
      },
    );
    print("Body type inserted or updated successfully for $email.");
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
      'UPDATE FitnessProfile SET FP_MedicalConditions = @medicalCondition WHERE FP_UserID = @email',
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
      'UPDATE FitnessProfile SET FP_Injuries = @injuries WHERE FP_UserID = @email',
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

  Future<Map<String, dynamic>> fetchAndUpsertHealthData() async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email == null) {
      throw Exception("No user is currently logged in.");
    }

    // Fetch health data
    var result = await conn.query(
      'SELECT fp_currentweight, fp_currentheight, fp_waistcircumference, fp_neckcircumference, fp_age, fp_gender FROM fitnessprofile WHERE FP_UserID = @email',
      substitutionValues: {'email': email},
    );

    if (result.isNotEmpty) {
      var row = result.first;

      // Explicitly parse the database values to double or int
      double weight = double.tryParse(row[0].toString()) ?? 0.0;
      double heightInMeters = double.tryParse(row[1].toString()) ?? 0.0;
      double waistCircumference = double.tryParse(row[2].toString()) ?? 0.0;
      double neckCircumference = double.tryParse(row[3].toString()) ?? 0.0;
      int age = int.tryParse(row[4].toString()) ?? 0;
      String gender = row[5].toString();

      // Calculate BMI, body fat, and daily calories
      double bmi = calculateBMI(weight, heightInMeters);
      double bodyFat = calculateBodyFat(
          waistCircumference, neckCircumference, heightInMeters,
          gender: gender);
      double dailyCalories = calculateDailyCalories(
          weight, heightInMeters * 100, age, gender, 1.55);

      // Upsert health data (insert or update)
      await conn.query(
        '''
      INSERT INTO FitnessGoal (FG_UserID, fg_StartBMI, FG_BodyFatPresentage, FG_DailyCalories)
      VALUES (@email, @bmi, @bodyFat, @dailyCalories)
      ON CONFLICT (FG_UserID) 
      DO UPDATE SET 
        fg_StartBMI = @bmi, 
        FG_BodyFatPresentage = @bodyFat, 
        FG_DailyCalories = @dailyCalories
      ''',
        substitutionValues: {
          'email': email,
          'bmi': bmi,
          'bodyFat': bodyFat,
          'dailyCalories': dailyCalories,
        },
      );
      print("Health data inserted or updated successfully for $email.");

      // Return the health data as a Map
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
      'SELECT username FROM Users WHERE userEmail = @email',
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
      'SELECT username, userEmail, userPassword FROM Users WHERE userEmail = @email',
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

   // Method to save the fitness goal for the currently logged-in user
  Future<void> saveFitnessGoal(String goal) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email != null) {
      await conn.query(
        'UPDATE fitnessgoal SET fg_Fitness_Goal = @goal WHERE fg_userid = @email',
        substitutionValues: {
          'goal': goal,
          'email': email,
        },
      );
      print("Fitness goal saved for user $email: $goal");
    } else {
      print("No user logged in.");
    }
  }

   // Method to save the selected muscle groups for the currently logged-in user
  Future<void> saveSelectedMuscleGroups(List<String> selectedGroups) async {
    final conn = await getConnection();
    final email = SessionManager.getUserEmail();

    if (email != null) {
      // You can save the selected muscle groups as a comma-separated string or in a new table
      String selectedGroupsString = selectedGroups.join(',');

      await conn.query(
        'UPDATE fitnessgoal SET FG_FocusMuscle_GroupName = @selectedGroups WHERE fg_userid = @email',
        substitutionValues: {
          'selectedGroups': selectedGroupsString,
          'email': email,
        },
      );
      print(
          "Selected muscle groups saved for user $email: $selectedGroupsString");
    } else {
      print("No user logged in.");
    }
  }

   // Method to save the fitness goal (number of workout days)
  Future<void> saveFitnessGoaldays(int workoutDays) async {
    final email = SessionManager.getUserEmail(); // Get the current user's email
    if (email == null) {
      print("No user is currently logged in");
      return;
    }

    final conn = await getConnection();
    await conn.query(
      """
    INSERT INTO fitnessgoal (fg_userid, FG_WorkoutDaysPerWeek) 
    VALUES (@userEmail, @workoutDays)
    ON CONFLICT (fg_userid) 
    DO UPDATE SET FG_WorkoutDaysPerWeek = EXCLUDED.FG_WorkoutDaysPerWeek
    """,
      substitutionValues: {'userEmail': email, 'workoutDays': workoutDays},
    );

    print("Fitness goal saved: $workoutDays days per week");
  }


   Future<void> saveTargetWeightToDatabase(double targetWeightInKg) async {
    final conn = await getConnection(); // Get the database connection

    // Get the current user's email from the SessionManager
    String? currentUserEmail = SessionManager.getUserEmail();

    if (currentUserEmail == null) {
      throw Exception('No user is logged in');
    }

    final result = await conn.query(
      '''
    INSERT INTO fitnessgoal (fg_userid, fg_targetweight)
    VALUES (@userEmail, @targetWeight)
    ON CONFLICT (fg_userid)
    DO UPDATE SET fg_targetweight = EXCLUDED.fg_targetweight
    ''',
      substitutionValues: {
        'targetWeight': targetWeightInKg,
        'userEmail': currentUserEmail,
      },
    );

    print("Target weight saved successfully for $currentUserEmail.");
  }

  

   /// Fetch the ID of predefined equipment by name and type
  Future<int> fetchPredefinedEquipmentID(String equipmentName, String equipmentType) async {
    final conn = await getConnection();

    try {
      final result = await conn.query(
        '''
        SELECT EquipmentID 
        FROM Equipment 
        WHERE EquipmentName = @equipmentName AND EquipmentType = @equipmentType
        ''',
        substitutionValues: {
          'equipmentName': equipmentName,
          'equipmentType': equipmentType,
        },
      );

      if (result.isNotEmpty) {
        return result.first[0] as int;
      } else {
        throw Exception("Equipment not found: $equipmentName, $equipmentType");
      }
    } catch (e) {
      print("Error fetching equipment ID: $e");
      rethrow;
    }
  }

  /// Bulk insert fixed weights for a user and equipment
  Future<void> bulkInsertFixedWeights(
    String userID,
    List<double> weights,
    int equipmentID,
    int count,
  ) async {
    final conn = await getConnection();

    try {
      for (double weight in weights) {
        await conn.query(
          '''
          INSERT INTO UserEquipmentFixed (EquipmentID, UserID, UEF_Weight, UEF_Count)
          VALUES (@equipmentID, @userID, @weight, @count)
          ON CONFLICT DO NOTHING
          ''',
          substitutionValues: {
            'equipmentID': equipmentID,
            'userID': userID,
            'weight': weight,
            'count': count,
          },
        );
      }
      print("Fixed weights inserted successfully for $userID.");
    } catch (e) {
      print("Error inserting fixed weights: $e");
      rethrow;
    }
  }

  /// Insert adjustable equipment data
  Future<int> insertUserEquipmentAdjustable(
    int equipmentID,
    String userID,
    double weightMin,
    double weightMax,
    int pairs,
  ) async {
    final conn = await getConnection();

    try {
      final result = await conn.query(
        '''
        INSERT INTO UserEquipmentAdjustable (EquipmentID, UserID, UEA_WeightMin, UEA_WeightMax, UEA_Pairs)
        VALUES (@equipmentID, @userID, @weightMin, @weightMax, @pairs)
        RETURNING UEA_ID
        ''',
        substitutionValues: {
          'equipmentID': equipmentID,
          'userID': userID,
          'weightMin': weightMin,
          'weightMax': weightMax,
          'pairs': pairs,
        },
      );

      if (result.isNotEmpty) {
        return result.first[0] as int;
      } else {
        throw Exception("Failed to insert adjustable equipment for $userID.");
      }
    } catch (e) {
      print("Error inserting adjustable equipment: $e");
      rethrow;
    }
  }

  /// Bulk insert plates for adjustable equipment
  Future<void> bulkInsertAdjustablePlates(int adjustableID, Map<double, int> plates) async {
    final conn = await getConnection();

    try {
      for (var entry in plates.entries) {
        double plateWeight = entry.key;
        int plateCount = entry.value;

        await conn.query(
          '''
          INSERT INTO UserEquipmentPlates (UEA_ID, PlateWeight, PlateCount)
          VALUES (@adjustableID, @plateWeight, @plateCount)
          ON CONFLICT DO NOTHING
          ''',
          substitutionValues: {
            'adjustableID': adjustableID,
            'plateWeight': plateWeight,
            'plateCount': plateCount,
          },
        );
      }
      print("Plates inserted successfully for adjustable equipment ID $adjustableID.");
    } catch (e) {
      print("Error inserting plates: $e");
      rethrow;
    }
  }
 Future<void> insertOtherEquipmentFixed(String userID, int equipmentID, double weight, int count) async {
  final db = await getConnection();

  try {
    // Use a default weight (e.g., 0.0) if the equipment doesn't have a meaningful weight
    final validWeight = weight > 0.0 ? weight : 0.0;

    await db.query(
      '''
      INSERT INTO UserEquipmentFixed (EquipmentID, UserID, UEF_Weight, UEF_Count)
      VALUES (@equipmentID, @userID, @weight, @count)
      ON CONFLICT (EquipmentID, UserID, UEF_Weight)
      DO UPDATE SET UEF_Count = UserEquipmentFixed.UEF_Count + EXCLUDED.UEF_Count
      ''',
      substitutionValues: {
        'equipmentID': equipmentID,
        'userID': userID,
        'weight': validWeight,
        'count': count,
      },
    );

    print("Equipment with ID $equipmentID inserted/updated successfully for user $userID.");
  } catch (e) {
    print("Error inserting equipment: $e");
    rethrow;
  }
}
// Method to insert target date for fitness goal
Future<void> insertFitnessGoal(String userID, DateTime startDate, DateTime targetDate) async {
  final conn = await getConnection();
  try {
    final durationInMonths = (targetDate.year - startDate.year) * 12 +
        (targetDate.month - startDate.month);
    await conn.query(
      '''
      INSERT INTO FitnessGoal (FG_UserID, FG_StartDate, FG_TargetDate, FG_DurationInMonths)
      VALUES (@userID, @startDate, @targetDate, @duration)
      ON CONFLICT (FG_UserID)
      DO UPDATE SET 
        FG_StartDate = EXCLUDED.FG_StartDate, 
        FG_TargetDate = EXCLUDED.FG_TargetDate, 
        FG_DurationInMonths = EXCLUDED.FG_DurationInMonths;
      ''',
      substitutionValues: {
        'userID': userID,
        'startDate': DateFormat('yyyy-MM-dd').format(startDate),
        'targetDate': DateFormat('yyyy-MM-dd').format(targetDate),
        'duration': durationInMonths,
      },
    );
    print("Fitness goal inserted/updated successfully.");
  } catch (e) {
    print("Error inserting fitness goal: $e");
  }
}
//for q10, method to insert general equipment only.
Future<void> insertMultipleOtherEquipmentFixed(Set<String> selectedEquipment) async {
  final db = await getConnection();

  // Fetch the current user's email from the session manager
  final userID = SessionManager.getUserEmail();

  if (userID == null) {
    print("No user is logged in.");
    throw Exception("No user is logged in.");
  }

  // Define non-weighted equipment explicitly
  final nonWeightedEquipment = {"Skipping Rope", "Fitness Bench", "Resistance Band"};

  try {
    for (final equipment in selectedEquipment) {
      if (equipment != "Dumbbell" &&
          equipment != "Barbell" &&
          equipment != "Kettlebell") {
        try {
          // Fetch predefined equipment ID
          final equipmentID = await fetchPredefinedEquipmentID(equipment, "General");

          // Determine if the equipment is weighted
          final isWeighted = !nonWeightedEquipment.contains(equipment);

          // Insert the equipment into the database
          await insertOtherEquipmentFixed(
            userID,
            equipmentID,
            isWeighted ? 1.0 : 0.0, // Use 1.0 for weighted, 0.0 for non-weighted
            1, // Default count
          );

          print("$equipment (${isWeighted ? "weighted" : "non-weighted"}) inserted successfully.");
        } catch (e) {
          print("Error inserting $equipment: $e");
        }
      }
    }
  } catch (e) {
    print("Error inserting multiple equipment: $e");
    rethrow;
  }
}

Future<Map<String, dynamic>> fetchUserFitnessDetails() async {
    final email = SessionManager.getUserEmail();
  if (email == null) {
    throw Exception("No user email found in session.");
  }

  final conn = await getConnection();

  try {
    // Query for user and fitness details
    final query = '''
    SELECT 
        u.useremail,
        u.username,
        fp.fp_currentweight AS weight,
        fp.fp_currentheight AS height,
        fp.fp_gender AS gender,
        fp.fp_waistcircumference AS waist_circumference,
        fp.fp_neckcircumference AS neck_circumference,
        fp.fp_fitnessbackground AS fitness_background,
        fp.fp_injuries AS injuries,
        fp.fp_medicalconditions AS medical_conditions,
        fg.fg_fitness_goal AS goal,
        fg.fg_targetweight AS target_weight,
        fg.fg_targetdate AS target_date,
        fg.fg_startdate AS start_date,
        fg.fg_enddate AS end_date,
        fg.fg_workoutperiod AS workout_period,
        fg.fg_startbmi AS start_bmi,
        fg.fg_workoutdaysperweek AS workout_days_per_week
    FROM 
        users u
    JOIN 
        fitnessprofile fp ON u.useremail = fp.fp_userid
    JOIN 
        fitnessgoal fg ON u.useremail = fg.fg_userid
    WHERE 
        u.useremail = @userEmail;
    ''';

    final result = await conn.query(query, substitutionValues: {'userEmail': email});
    if (result.isEmpty) {
      throw Exception("No data found for email: $email");
    }

    final row = result.first;

    // Query for equipment details
    final equipmentQuery = '''
    SELECT 
        e.EquipmentName, 
        e.EquipmentType,
        uef.UEF_Weight, 
        uef.UEF_Count,
        uea.UEA_WeightMin, 
        uea.UEA_WeightMax, 
        uea.UEA_Pairs,
        uep.PlateWeight, 
        uep.PlateCount
    FROM Equipment e
    LEFT JOIN UserEquipmentFixed uef ON e.EquipmentID = uef.EquipmentID
    LEFT JOIN UserEquipmentAdjustable uea ON e.EquipmentID = uea.EquipmentID
    LEFT JOIN UserEquipmentPlates uep ON uea.UEA_ID = uep.UEA_ID
    WHERE uef.UserID = @userEmail OR uea.UserID = @userEmail;
    ''';

    final equipmentResult = await conn.query(equipmentQuery, substitutionValues: {'userEmail': email});
    final equipmentDetails = {};

    // Parse equipment data
    for (var eqRow in equipmentResult) {
      final equipmentName = eqRow[0]; // EquipmentName
      final equipmentType = eqRow[1]; // EquipmentType

      if (!equipmentDetails.containsKey(equipmentName)) {
        equipmentDetails[equipmentName] = [];
      }

      if (equipmentType == "Fixed") {
        equipmentDetails[equipmentName].add({
          "type": equipmentType,
          "weight": eqRow[2] ?? "Unknown", // UEF_Weight
          "count": eqRow[3] ?? 1,          // UEF_Count
        });
      } else if (equipmentType == "Adjustable") {
        final existingEquipment = equipmentDetails[equipmentName]
            .firstWhere(
              (item) => item["type"] == "Adjustable",
              orElse: () => null,
            );

        if (existingEquipment == null) {
          equipmentDetails[equipmentName].add({
            "type": equipmentType,
            "weight_range": {
              "min": eqRow[4] ?? "Unknown", // UEA_WeightMin
              "max": eqRow[5] ?? "Unknown", // UEA_WeightMax
            },
            "pairs": eqRow[6] ?? 1, // UEA_Pairs
            "plates": [],
          });
        }

        // Add plates to the "plates" array of the corresponding equipment
        final plates = {
          "weight": eqRow[7], // PlateWeight
          "count": eqRow[8],  // PlateCount
        };
        if (plates["weight"] != null && plates["count"] != null) {
          equipmentDetails[equipmentName].last["plates"].add(plates);
        }
      } else if (equipmentType == "General") {
        equipmentDetails[equipmentName].add({
          "type": equipmentType,
          "description": "General equipment, no weights or pairs",
        });
      } else if (equipmentType == "None") {
        equipmentDetails[equipmentName] = "No equipment used.";
      }
    }

    // Include general equipment explicitly
    equipmentDetails["other_equipment"] = ["Skipping Rope", "Fitness Bench"];

    // Build the JSON response
    final jsonResult = {
      "user_info": {
        "email": row[0],
        "username": row[1],
      },
      "fitness_details": {
        "current_weight": row[2],
        "current_height": row[3],
        "gender": row[4],
        "waist_circumference": row[5],
        "neck_circumference": row[6],
        "fitness_background": row[7],
        "injuries": row[8],
        "medical_conditions": row[9],
        "goal": {
          "fitness_goal": row[10],
          "target_weight": row[11],
          "target_date": row[12]?.toString(),
          "start_date": row[13]?.toString(),
          "end_date": row[14]?.toString(),
          "workout_period": row[15],
          "start_bmi": row[16],
          "workout_days_per_week": row[17]
        },
        "equipment": equipmentDetails,
      }
    };

    // Log and return JSON
    String jsonString = jsonEncode(jsonResult);
    print("Fetched JSON Data: $jsonString");
    return jsonResult;
  } catch (e) {
    print("Error fetching user fitness details: $e");
    rethrow;
    }
  }
    Future<Map<String, dynamic>> getMealPlanData(String userEmail) async {
    final conn = await getConnection();
    try {
      final result = await conn.query(
        '''
        SELECT total_carbs, total_fat, total_fiber, total_protein, total_calories
        FROM mealplan
        WHERE mp_id = (
          SELECT mealplanid FROM meal WHERE useremail = @userEmail LIMIT 1
        )
        ''',
        substitutionValues: {'userEmail': userEmail},
      );

      if (result.isNotEmpty) {
        return {
          'carbs': result.first[0],
          'fat': result.first[1],
          'fiber': result.first[2],
          'protein': result.first[3],
          'calories': result.first[4],
        };
      }
    } catch (e) {
      print("Error fetching meal plan data: $e");
    }
    return {};
    }
  
    Future<Map<String, dynamic>> getFitnessProgress(String userEmail) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT fg_fitness_goal, fg_startdate, fg_targetdate
      FROM fitnessgoal
      WHERE fg_userid = @userEmail
      ''',
      substitutionValues: {'userEmail': userEmail},
    );

    if (results.isNotEmpty) {
      final row = results.first;
      final fitnessGoal = row[0];
      final startDate = row[1] as DateTime;
      final targetDate = row[2] as DateTime;

      final today = DateTime.now();
      final completedDays = today.difference(startDate).inDays;
      final totalDays = targetDate.difference(startDate).inDays;
      final totalWeeks = (totalDays / 7).ceil();


      return {
        'fitnessGoal': fitnessGoal,
        'completedDays': completedDays,
        'totalDays': totalDays,
        'totalWeeks': totalWeeks,
      };
    } else {
      throw Exception("No fitness goal found for user ID: $userEmail");
    }
  } catch (e) {
    print("Error fetching fitness progress: $e");
    throw e;
  }
}
    Future<int> getWorkoutDaysPerWeek(String userEmail) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT fg_workoutdaysperweek
      FROM fitnessgoal
      WHERE fg_userid = @userEmail
      ''',
      substitutionValues: {'userEmail': userEmail},
    );

    if (results.isNotEmpty) {
      final row = results.first;
      final workoutDaysPerWeek = row[0] as int;
      return workoutDaysPerWeek;
    } else {
      throw Exception("No fitness goal found for user ID: $userEmail");
    }
  } catch (e) {
    print("Error fetching workout days per week: $e");
    throw e;
  }
}
Future<Map<int, int>> getTotalDurationPerDay(String userEmail, int weekNumber) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT day_number, SUM(ue_duration) as total_duration
      FROM userexercise
      WHERE userid = @userEmail AND week_number = @weekNumber
      GROUP BY day_number
      ORDER BY day_number
      ''',
      substitutionValues: {'userEmail': userEmail, 'weekNumber': weekNumber},
    );

    Map<int, int> durationPerDay = {};
    for (final row in results) {
      final dayNumber = row[0] as int;
      final totalDuration = row[1] != null ? row[1] as int : 0;
      durationPerDay[dayNumber] = totalDuration;
    }
    print("Total duration per day for week $weekNumber fetched successfully.");

    return durationPerDay;
  } catch (e) {
    print("Error fetching total duration per day for week $weekNumber: $e");
    throw e;
  }
}
Future<List<Map<String, dynamic>>> getWeeklyDurations(String userEmail) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT
        ue.week_number AS week,
        SUM(ue.ue_duration) AS total_duration
      FROM userexercise ue
      WHERE ue.userid = @userEmail
      GROUP BY ue.week_number
      ORDER BY ue.week_number ASC;
      ''',
      substitutionValues: {'userEmail': userEmail},
    );

    List<Map<String, dynamic>> weeklyDurations = [];
    for (final row in results) {
      weeklyDurations.add({
        'week': row[0],
        'total_duration': row[1],
      });
    }

    return weeklyDurations;
  } catch (e) {
    print("Error fetching weekly durations: $e");
    throw e;
  }
}
Future<double> getTotalDuration(String userEmail) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT SUM(ue_duration) as total_duration
      FROM userexercise
      WHERE userid = @userEmail
      ''',
      substitutionValues: {'userEmail': userEmail},
    );

    if (results.isNotEmpty) {
      final totalDuration = results.first[0];
      return totalDuration != null ? totalDuration / 60 : 0.0; // Convert minutes to hours
    } else {
      return 0.0;
    }
  } catch (e) {
    print("Error fetching total duration: $e");
    throw e;
  }
}
Future<double> getCurrentWeight(String userEmail) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT fp_currentweight
      FROM fitnessprofile
      WHERE fp_userid = @userEmail
      ''',
      substitutionValues: {'userEmail': userEmail},
    );

    if (results.isNotEmpty) {
      final currentWeight = results.first[0];
      return currentWeight != null ? double.parse(currentWeight.toString()) : 0.0;
    } else {
      throw Exception("No current weight found for user ID: $userEmail");
    }
  } catch (e) {
    print("Error fetching current weight: $e");
    throw e;
  }
}
Future<double> getTargetWeight(String userEmail) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT fg_targetweight
      FROM fitnessgoal
      WHERE fg_userid = @userEmail
      ''',
      substitutionValues: {'userEmail': userEmail},
    );

    if (results.isNotEmpty) {
      final targetWeight = results.first[0];
      return targetWeight != null ? double.parse(targetWeight.toString()) : 0.0;
    } else {
      throw Exception("No target weight found for user ID: $userEmail");
    }
  } catch (e) {
    print("Error fetching target weight: $e");
    throw e;
  }
}
Future<void> updateCurrentWeight(String userEmail, double newCurrentWeight) async {
  try {
    final connection = await getConnection();
    await connection.query(
      '''
      UPDATE fitnessprofile
      SET fp_currentweight = @newCurrentWeight
      WHERE fp_userid = @userEmail
      ''',
      substitutionValues: {
        'newCurrentWeight': newCurrentWeight,
        'userEmail': userEmail,
      },
    );
    print("Current weight updated successfully for $userEmail");
  } catch (e) {
    print("Error updating current weight: $e");
    throw e;
  }
}
 Future<List<Map<String, dynamic>>> getDinnerMeals(String email) async {
    final conn = await getConnection();
    try {
      final result = await conn.mappedResultsQuery(
        '''
        SELECT ms.ms_name, ms.ms_calories, ms.ms_protein, ms.ms_fat, ms.ms_fiber, ms.ms_carbs
        FROM meal m
        JOIN mealsuggestions ms ON m.m_id = ms.mealid
        WHERE m.useremail = @userEmail AND m.m_type = 'Dinner'
        ''',
        substitutionValues: {'userEmail': email},
      );

      return result.map((row) => row.values.first).toList();
    } catch (e) {
      print("Error fetching dinner meals: \$e");
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getlunchMeals(String email) async {
    final conn = await getConnection();
    try {
      final result = await conn.mappedResultsQuery(
        '''
        SELECT ms.ms_name, ms.ms_calories, ms.ms_protein, ms.ms_fat, ms.ms_fiber, ms.ms_carbs
        FROM meal m
        JOIN mealsuggestions ms ON m.m_id = ms.mealid
        WHERE m.useremail = @userEmail AND m.m_type = 'Lunch'
        ''',
        substitutionValues: {'userEmail': email},
      );

      return result.map((row) => row.values.first).toList();
    } catch (e) {
      print("Error fetching Lunch meals: \$e");
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getbreakfastMeals(String email) async {
    final conn = await getConnection();
    try {
      final result = await conn.mappedResultsQuery(
        '''
        SELECT ms.ms_name, ms.ms_calories, ms.ms_protein, ms.ms_fat, ms.ms_fiber, ms.ms_carbs
        FROM meal m
        JOIN mealsuggestions ms ON m.m_id = ms.mealid
        WHERE m.useremail = @userEmail AND m.m_type = 'Breakfast'
        ''',
        substitutionValues: {'userEmail': email},
      );

      return result.map((row) => row.values.first).toList();
    } catch (e) {
      print("Error fetching Breakfast meals: \$e");
      return [];
    }
  }
   Future<int> getUniqueDaysDone(String userEmail) async {
    try {
      final connection = await getConnection();
      final results = await connection.query(
        '''
        SELECT DISTINCT day_number, week_number
        FROM userexercise
        WHERE userid = @userEmail
        ''',
        substitutionValues: {'userEmail': userEmail},
      );

      return results.length; // Number of unique days done
    } catch (e) {
      print("Error fetching unique days done: $e");
      throw e;
    }
  }
  Future<List<Map<String, dynamic>>> getWeightHistory(String userEmail) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT wh_recordedat, wh_weight
      FROM weighthistory
      WHERE wh_userid = @userEmail
      ORDER BY wh_recordedat ASC
      ''',
      substitutionValues: {'userEmail': userEmail},
    );

    // Convert results to a list of maps
    return results.map((row) {
      return {
        'recordedAt': DateTime.parse(row[0].toString()),
        'weight': double.parse(row[1].toString()),
      };
    }).toList();
  } catch (e) {
    // Use a logging framework instead of print
    print("Error fetching weight history: $e");
    rethrow;
  }
}
Future<double> getBeginningWeight(String userEmail) async {
  try {
    final connection = await getConnection();
    final results = await connection.query(
      '''
      SELECT wh.wh_weight
      FROM weighthistory wh
      JOIN fitnessgoal fg ON wh.wh_userid = fg.fg_userid
      WHERE wh.wh_userid = @userEmail AND DATE(wh.wh_recordedat) = fg.fg_startdate
      ''',
      substitutionValues: {'userEmail': userEmail},
    );

    if (results.isNotEmpty) {
      final beginningWeight = results.first[0];
      return beginningWeight != null ? double.parse(beginningWeight.toString()) : 0.0;
    } else {
      throw Exception("No beginning weight found for user ID: $userEmail");
    }
  } catch (e) {
    print("Error fetching beginning weight: $e");
    throw e;
  }
}
}


