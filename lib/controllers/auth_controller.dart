import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import './../repository/repository.dart';
import 'package:flutter/material.dart';
import './../models/models.dart';
import './controllers.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  var logado = false.obs;
  var carregando = false.obs;
  var erro = ''.obs;
  final box = GetStorage();

  // Resposta do login
  final Rx<LoginResponseModel?> loginResponse = Rx<LoginResponseModel?>(null);

  // Efetuar login
  Future<void> login(LoginRequestModel request) async {
    try {
      carregando.value = true;
      erro.value = '';

      final response = await authRepository.login(request);
      loginResponse.value = response;

      if (response != null) {
        logado.value = true;
        box.write('token', response.token);

        final userController = Get.find<UserController>();

        // Limpa dados antigos antes de salvar o novo usuário
        userController.user.value = null;
        userController.box.remove('usuario');

        // Buscar o user pelo username do LoginRequestModel
        final userModel = await Get.find<UserController>().userRepository
            .getUserByUsername(request.username);

        if (userModel != null) {
          // Atualiza o estado e storage com o usuário novo
          userController.user.value = userModel;
          userController.box.write('usuario', jsonEncode(userModel.toJson()));

          // 👉 Garante que ao entrar vá direto para a aba Home
          Get.find<MainNavigationController>().changePage(0);
          Get.offAllNamed('/');
        }
      } else {
        logado.value = false;
      }
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }

  void logout() {
    logado.value = false;
    box.remove('token');
    box.remove('usuario');

    Get.snackbar(
      'Logout',
      'Você saiu da sua conta com sucesso.',
      colorText: Colors.white,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.logout, color: Colors.white),
      duration: const Duration(seconds: 3),
    );

    Get.offAllNamed('/');
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      carregando.value = true;

      final userController = Get.find<UserController>();
      final currentUser = userController.user.value;

      if (currentUser == null) {
        erro.value = 'Usuário não carregado';
        return false;
      }

      final dbUser = await userController.userRepository.localRepository
          .getUserById(currentUser.id);

      if (dbUser == null ||
          dbUser.password.trim() !=
              UserModel.hashPassword(oldPassword.trim())) {
        erro.value = 'Senha atual incorreta';
        return false;
      }
      if (newPassword.trim().isEmpty) {
        erro.value = 'Nova senha não pode ser vazia';
        return false;
      }

      final updatedUser = dbUser.copyWith(
        password: UserModel.hashPassword(newPassword.trim()),
      );

      userController.user.value = updatedUser;

      await userController.userRepository.saveUser(updatedUser);
      box.write('usuario', jsonEncode(updatedUser.toJson()));

      return true;
    } catch (e) {
      erro.value = 'Erro ao trocar a senha';
      return false;
    } finally {
      carregando.value = false;
    }
  }
}
