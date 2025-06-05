import '../../models/cat_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class CatLocalDataSource {
  Future<List<CatModel>> getCachedCats();
  Future<void> cacheCats(List<CatModel> cats);
  Future<List<CatModel>> getLikedCats();
  Future<void> likeCat(CatModel cat);
  Future<void> unlikeCat(String id);
}


class CatLocalDataSourceImpl implements CatLocalDataSource {
  final Database database;

  CatLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheCats(List<CatModel> cats) async {
    final batch = database.batch();

    for (final cat in cats) {
      batch.insert(
        'cats',
        cat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  @override
  Future<List<CatModel>> getCachedCats() async {
    final maps = await database.query('cats');
    return maps.map(CatModel.fromMap).toList();
  }

  @override
  Future<List<CatModel>> getLikedCats() async {
    final maps = await database.query(
      'liked_cats',
      orderBy: 'likedTimestamp DESC',
    );
    return maps.map(CatModel.fromMap).toList();
  }

  @override
  Future<void> likeCat(CatModel cat) async {
    await database.insert(
      'liked_cats',
      cat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> unlikeCat(String id) async {
    await database.delete(
      'liked_cats',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}