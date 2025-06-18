import 'package:sqflite/sqlite_api.dart';

import '../database.dart';

class Favorite {
  Future<void> addFavorito(
    int userId,
    int productId,
    String dataFavorito,
  ) async {
    final db = await AppDatabase().database;
    await db.insert('favorite', {
      'userId': userId,
      'productId': productId,
      'dataFavorito': dataFavorito,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
