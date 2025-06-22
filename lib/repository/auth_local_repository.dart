import 'package:sqflite/sqlite_api.dart';
import './../database/app_database.dart';
import './../models/models.dart';

class AuthLocalRepository {
  // Salva token para usuário
  Future<void> saveAuth(String username, String token) async {
    final db = await AppDatabase().database;
    await db.insert('auth', {
      'username': username,
      'token': token,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Busca token pelo username
  Future<LoginResponseModel?> getAuthByUsername(String username) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'auth',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return LoginResponseModel(token: map['token'] as String);
    }

    return null;
  }
}
