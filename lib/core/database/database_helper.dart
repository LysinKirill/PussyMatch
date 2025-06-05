import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static Future<Database> initializeDatabase(String path) async {
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE cats (
            id TEXT PRIMARY KEY,
            imageUrl TEXT NOT NULL,
            breedId TEXT NOT NULL,
            breedName TEXT NOT NULL,
            breedDescription TEXT NOT NULL,
            likedTimestamp INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE liked_cats (
            id TEXT PRIMARY KEY,
            imageUrl TEXT NOT NULL,
            breedId TEXT NOT NULL,
            breedName TEXT NOT NULL,
            breedDescription TEXT NOT NULL,
            likedTimestamp INTEGER NOT NULL
          )
        ''');
      },
    );
  }
}
