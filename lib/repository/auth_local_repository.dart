import 'package:sqflite/sqlite_api.dart';

import './../database/app_database.dart';
import './../models/models.dart';

class AuthLocalRepository {
  Future<void> saveAuth(String username, String token) async {
    final db = await AppDatabase().database;
    await db.insert('auth', {
      'username': username,
      'token': token,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<LogiResponsenModel?> login(LoginRequestModel request) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'auth',
      where: 'username = ? AND password = ?',
      whereArgs: [request.username, request.password],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return LogiResponsenModel(token: map['token'] as String);
    }

    return null;
  }

  Future<LogiResponsenModel?> getAuthByUsername(String username) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'auth',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return LogiResponsenModel(token: map['token'] as String);
    }

    return null;
  }
}
