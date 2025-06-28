import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import './../repository/repository.dart';
import './../models/user_model.dart';

class UserController extends GetxController {
  final UserRepository userRepository;

  UserController({required this.userRepository});

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final box = GetStorage();
  var carregando = false.obs;
  var erro = ''.obs;

  // Campos de erro reativos
  final RxString usernameError = ''.obs;
  final RxString emailError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (box.hasData('usuario')) {
      final jsonUser = box.read('usuario');
      try {
        user.value = UserModel.fromJson(json.decode(jsonUser));
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao carregar usuário do storage: $e');
        }
      }
    }
  }

  // Limpa o erro do username (chame quando o usuário começa a digitar)
  void clearUsernameError() {
    if (usernameError.value.isNotEmpty) {
      usernameError.value = '';
    }
  }

  // Limpa o erro do email (chame quando o usuário começa a digitar)
  void clearEmailError() {
    if (emailError.value.isNotEmpty) {
      emailError.value = '';
    }
  }

  Future<bool> validateUsername(String username) async {
    if (username.trim().isEmpty) {
      usernameError.value = 'Informe o nome de usuário';
      return false;
    }

    final existingUser = await userRepository.getUserByUsername(username);
    if (existingUser != null) {
      usernameError.value = 'Usuário já cadastrado';
      return false;
    }

    usernameError.value = '';
    return true;
  }

  Future<bool> validateEmail(String email) async {
    if (email.trim().isEmpty) {
      emailError.value = 'Informe o e-mail';
      return false;
    }

    // Verifica localmente primeiro
    final localUser = await userRepository.localRepository.getUserByEmail(
      email.trim(),
    );
    if (localUser != null) {
      emailError.value = 'E-mail já cadastrado';
      return false;
    }

    // Caso não exista localmente, verifica no remoto
    final users = await userRepository.remoteRepository.userService
        .fetchUsers();
    final exists = users.any((u) => u.email == email.trim());
    if (exists) {
      emailError.value = 'E-mail já cadastrado';
      return false;
    }

    emailError.value = '';
    return true;
  }

  Future<void> fetchUserById(int id) async {
    try {
      final fetchedUser = await userRepository.getUserById(id);
      user.value = fetchedUser;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar usuário: $e');
      }
    }
  }

  Future<void> saveUser(UserModel userModel) async {
    try {
      carregando.value = true;
      erro.value = '';
      await userRepository.saveUser(userModel);
      carregando.value = false;
    } catch (e) {
      erro.value = e.toString();
      carregando.value = false;
    }
  }

  Future<bool> updateUserReturningSuccess(UserModel userModel) async {
    try {
      carregando.value = true;
      erro.value = '';
      await userRepository.saveUser(userModel);
      box.write('usuario', jsonEncode(userModel.toJson()));
      user.value = userModel;
      carregando.value = false;
      return true;
    } catch (e) {
      erro.value = e.toString();
      carregando.value = false;
      return false;
    }
  }
}
