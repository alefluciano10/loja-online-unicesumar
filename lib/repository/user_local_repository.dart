import 'package:sqflite/sqlite_api.dart';
import './../database/app_database.dart';
import './../models/models.dart';

class UserLocalRepository {
  Future<UserModel?> getUserById(int id) async {
    final db = await AppDatabase().database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  Future<UserModel?> getUserByUsernameAndPassword(
    String username,
    String hashedPassword,
  ) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username.trim(), hashedPassword],
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }

    return null;
  }

  Future<UserModel?> getUserByName(String userName) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [userName.trim()],
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  // Novo método para buscar usuário por email
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim()],
    );

    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  Future<UserModel?> login(LoginRequestModel request) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [request.username.trim()],
    );

    if (maps.isEmpty) return null;

    final user = _fromMap(maps.first);

    final hashedInputPassword = UserModel.hashPassword(request.password);
    return user.password == hashedInputPassword ? user : null;
  }

  Future<int> insertUser(UserModel user) async {
    final db = await AppDatabase().database;
    final data = _toMap(user);
    data.remove('id'); // Banco irá gerar automaticamente

    return await db.insert(
      'users',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(UserModel user) async {
    final db = await AppDatabase().database;
    final data = _toMap(user)
      ..['id'] = user.id; // adiciona id manualmente para update
    await db.update('users', data, where: 'id = ?', whereArgs: [user.id]);
  }

  Future<UserModel> saveUser(UserModel user) async {
    if (user.id == 0) {
      final id = await insertUser(user);
      return user.copyWith(id: id);
    } else {
      await updateUser(user);
      return user;
    }
  }

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

  Map<String, Object?> _toMap(UserModel user) {
    return {
      // 'id' será adicionado no update manualmente
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
