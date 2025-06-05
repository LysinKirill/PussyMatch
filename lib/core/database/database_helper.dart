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
            breedTemperament TEXT NOT NULL,
            breedOrigin TEXT NOT NULL,
            breedLifeSpan TEXT NOT NULL,
            breedWeight TEXT NOT NULL,
            breedAdaptability INTEGER NOT NULL,
            breedAffectionLevel INTEGER NOT NULL,
            breedChildFriendly INTEGER NOT NULL,
            breedDogFriendly INTEGER NOT NULL,
            breedEnergyLevel INTEGER NOT NULL,
            breedHealthIssues INTEGER NOT NULL,
            breedIntelligence INTEGER NOT NULL,
            breedSocialNeeds INTEGER NOT NULL,
            breedStrangerFriendly INTEGER NOT NULL,
            breedVocalisation INTEGER NOT NULL,
            breedWikipediaUrl TEXT NOT NULL,
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
            breedTemperament TEXT NOT NULL,
            breedOrigin TEXT NOT NULL,
            breedLifeSpan TEXT NOT NULL,
            breedWeight TEXT NOT NULL,
            breedAdaptability INTEGER NOT NULL,
            breedAffectionLevel INTEGER NOT NULL,
            breedChildFriendly INTEGER NOT NULL,
            breedDogFriendly INTEGER NOT NULL,
            breedEnergyLevel INTEGER NOT NULL,
            breedHealthIssues INTEGER NOT NULL,
            breedIntelligence INTEGER NOT NULL,
            breedSocialNeeds INTEGER NOT NULL,
            breedStrangerFriendly INTEGER NOT NULL,
            breedVocalisation INTEGER NOT NULL,
            breedWikipediaUrl TEXT NOT NULL,
            likedTimestamp INTEGER NOT NULL
          )
        ''');
      },
    );
  }
}
