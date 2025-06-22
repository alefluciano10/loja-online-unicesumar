import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import './../repository/repository.dart';
import './../models/user_model.dart';

class UserController extends GetxController {
  final UserRepository userRepository;

  UserController({required this.userRepository});

  // Usuário atual observável
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  var carregando = false.obs;
  var erro = ''.obs;
  final box = GetStorage();

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

  // Carregar um usuário pelo id
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

  // Salvar um usuário - agora recebe o usuário atualizado com id
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
      user.value = userModel; // Atualiza o usuário atual
      carregando.value = false;
      return true;
    } catch (e) {
      erro.value = e.toString();
      carregando.value = false;
      return false;
    }
  }
}
