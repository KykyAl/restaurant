import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    print(path.join(dbPath, 'favorite_restaurants.db'));

    return sql.openDatabase(
      path.join(dbPath, 'favorite_restaurants.db'),
      onCreate: (db, version) async {
        try {
          await db.execute('''
            CREATE TABLE favorite_restaurants (
     id TEXT PRIMARY KEY,
     name TEXT,
     description TEXT,
     city TEXT,
     address TEXT,
     pictureId INTEGER,
     rating REAL
            )
          ''');
        } catch (e) {
          print('Error creating table: $e');
        }
      },
      version: 1,
    );
  }

  static Future<void> addFavoriteRestaurant({
    required String id,
    required String name,
    String? description,
    String? city,
    String? address,
    String? pictureId,
    double? rating,
  }) async {
    final db = await DatabaseHelper.database();

    // Buat map data yang hanya berisi kolom-kolom yang memiliki nilai
    final data = {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (city != null) 'city': city,
      if (address != null) 'address': address,
      if (pictureId != null) 'pictureId': pictureId,
      if (rating != null) 'rating': rating,
    };

    await db.insert(
      'favorite_restaurants',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getFavoriteRestaurants() async {
    final db = await DatabaseHelper.database();
    return db.query('favorite_restaurants');
  }

  static Future<bool> isRestaurantInFavorites(String restaurantId) async {
    final db = await DatabaseHelper.database();
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM favorite_restaurants WHERE id = ?',
      [restaurantId],
    );

    final count = sql.Sqflite.firstIntValue(result);
    return count != null && count > 0;
  }

  static Future<int> deleteFavoriteRestaurant(String restaurantId) async {
    final db = await DatabaseHelper.database();
    return await db.rawDelete(
      'DELETE FROM favorite_restaurants WHERE id = ?',
      [restaurantId],
    );
  }
}
