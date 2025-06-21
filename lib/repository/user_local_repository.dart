import 'package:sqflite/sqlite_api.dart';
import '../database/app_database.dart';
import '../models/models.dart';

class UserLocalRepository {
  Future<UserModel?> getUserById(int id) async {
    final db = await AppDatabase().database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      final map = maps.first;
      return _fromMap(map);
    }

    return null;
  }

  Future<UserModel?> getUserByName(String userName) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [userName],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return _fromMap(map);
    }

    return null;
  }

  Future<void> saveUser(UserModel user) async {
    final db = await AppDatabase().database;

    // Verifica se já existe
    final existing = await getUserById(user.id);
    final data = _toMap(user);

    if (existing == null) {
      await db.insert(
        'users',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update('users', data, where: 'id = ?', whereArgs: [user.id]);
    }
  }

  Future<UserModel?> login(LoginRequestModel request) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'auth',
      where: 'username = ? AND password = ?',
      whereArgs: [request.username, request.password],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return _fromMap(map);
    }

    return null;
  }

  // Helper para converter Map em UserModel
  UserModel _fromMap(Map<String, Object?> map) {
    return UserModel(
      id: map['id'] as int,
      email: map['email'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      name: NameModel(
        firstname: map['firstname'] as String,
        lastname: map['lastname'] as String,
      ),
      address: AddressModel(
        city: map['city'] as String,
        street: map['street'] as String,
        number: map['number'] as int,
        zipcode: map['zipcode'] as String,
        geolocation: GeolocationModel(
          lat: map['lat'] as String,
          long: map['long'] as String,
        ),
      ),
      phone: map['phone'] as String,
    );
  }

  // Helper para converter UserModel em Map
  Map<String, Object?> _toMap(UserModel user) {
    return {
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'password': user.password,
      'firstname': user.name.firstname,
      'lastname': user.name.lastname,
      'city': user.address.city,
      'street': user.address.street,
      'number': user.address.number,
      'zipcode': user.address.zipcode,
      'lat': user.address.geolocation.lat,
      'long': user.address.geolocation.long,
      'phone': user.phone,
    };
  }
}
