import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import './../repository/repository.dart';
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

        // Buscar o user localmente (para garantir senha)
        final userModel = await Get.find<UserController>()
            .userRepository
            .localRepository
            .getUserByName(request.username);

        if (userModel != null) {
          box.write('usuario', jsonEncode(userModel.toJson()));
          Get.find<UserController>().user.value = userModel;

          // Carregar dados do user:
          Get.find<FavoritosController>().loadFavoritosForUser(userModel.id);
          Get.find<CartController>().loadCartForUser(userModel.id);
          Get.find<OrderController>().fetchOrdersForUser(userModel.id);
        } else {
          erro.value = 'Usuário não encontrado localmente';
          logado.value = false;
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
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.logout, color: Colors.white),
      duration: const Duration(seconds: 3),
    );

    Get.offAllNamed('/');
  }

  // Trocar senha
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

      // Verificar senha atual direto do banco
      final dbUser = await userController.userRepository.localRepository
          .getUserById(currentUser.id);

      if (dbUser == null || dbUser.password != oldPassword) {
        erro.value = 'Senha atual incorreta';
        return false;
      }

      // Atualiza a senha localmente
      final updatedUser = dbUser.copyWith(password: newPassword);
      userController.user.value = updatedUser;

      // Atualiza no repositório
      await userController.userRepository.saveUser(updatedUser);

      // Atualiza no storage
      box.write('usuario', jsonEncode(updatedUser.toJson()));

      erro.value = '';
      return true;
    } catch (e) {
      erro.value = 'Erro ao trocar a senha';
      return false;
    } finally {
      carregando.value = false;
    }
  }
}
