import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Create a singleton database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'user_cards.db');
    return openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE user_cards(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          card_number TEXT,
          card_holder_name TEXT,
          expiry_date TEXT,
          cvv TEXT,
          country TEXT,
          postal_code TEXT,
          email TEXT  // Add the email column here
        )
      ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          ALTER TABLE user_cards ADD COLUMN email TEXT;
        ''');
      }
    });
  }

  // Insert card details into the database
  static Future<int> insertCard(Map<String, dynamic> cardDetails) async {
    final db = await database;
    return await db.insert('user_cards', cardDetails);
  }

 // Method to get the newest card details by email
  static Future<Map<String, String>?> getNewestCardDetailsByEmail(
      String email) async {
    final db = await database;

    // Query to get the newest card details based on email, sorted by id in descending order
    List<Map<String, dynamic>> result = await db.query(
      'user_cards',
      where: 'email = ?',
      whereArgs: [email],
      orderBy:
          'id DESC', // Assuming 'id' is auto-incremented and reflects the newest card
      limit: 1, // Get only the newest card
    );

    // Check if a card was found
    if (result.isNotEmpty) {
      return {
        'email': result[0]['email'],
        'card_number': result[0]['card_number'],
        'card_holder_name': result[0]['card_holder_name'],
        'expiry_date': result[0]['expiry_date'],
        'cvv': result[0]['cvv'],
        'country': result[0]['country'],
        'postal_code': result[0]['postal_code'],
      };
    } else {
      return null; // No card found for the email
    }
  }


}
