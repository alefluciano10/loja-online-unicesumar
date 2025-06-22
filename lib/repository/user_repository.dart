import 'package:flutter/foundation.dart';
import '../repository/repository.dart';
import '../models/models.dart';

class UserRepository {
  final UserLocalRepository localRepository;
  final UserRemoteRepository remoteRepository;

  UserRepository(this.localRepository, this.remoteRepository);

  Future<UserModel?> getUserByUsername(String username) async {
    UserModel? user = await localRepository.getUserByName(username);
    if (user != null) return user;

    final users = await remoteRepository.userService.fetchUsers();
    try {
      return users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> login(LoginRequestModel request) async {
    final hashedPassword = UserModel.hashPassword(request.password.trim());

    // 1. Tenta login local
    UserModel? localUser = await localRepository.getUserByUsernameAndPassword(
      request.username,
      hashedPassword,
    );

    if (localUser != null) {
      if (kDebugMode) print('Usuário autenticado localmente.');
      return localUser;
    }

    // 2. Tenta login remoto (caso exista integração futura)
    final users = await remoteRepository.userService.fetchUsers();
    try {
      final remoteUser = users.firstWhere(
        (u) => u.username == request.username && u.password == hashedPassword,
      );
      // Salva localmente para sessões futuras
      await localRepository.saveUser(remoteUser);
      return remoteUser;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUserById(int id) async {
    UserModel? user = await localRepository.getUserById(id);
    if (user != null) {
      if (kDebugMode) print('Usuário encontrado localmente');
      return user;
    }

    if (kDebugMode) {
      print('Usuário não encontrado localmente. Buscando remoto...');
    }
    user = await remoteRepository.fetchUserById(id);

    if (user != null) {
      if (kDebugMode) {
        print('Usuário encontrado remoto. Salvando localmente...');
      }
      await localRepository.saveUser(user);
    } else {
      if (kDebugMode) print('Usuário não encontrado na API.');
    }

    return user;
  }

  /// Salva o usuário (novo ou existente) e retorna o modelo atualizado (com ID gerado, se aplicável)
  Future<UserModel> saveUser(UserModel user) async {
    if (user.id == 0) {
      // Novo usuário: insere e recebe id
      final generatedId = await localRepository.insertUser(user);
      final savedUser = user.copyWith(id: generatedId);
      return savedUser;
    } else {
      // Usuário existente: apenas atualiza
      await localRepository.updateUser(user);
      return user;
    }
  }
}
