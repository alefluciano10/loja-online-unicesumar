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
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;
  final RxString firstNameError = ''.obs;
  final RxString lastNameError = ''.obs;
  final RxString phoneError = ''.obs;

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

  // Limpa erros ao começar digitar
  void clearUsernameError() {
    if (usernameError.value.isNotEmpty) {
      usernameError.value = '';
    }
  }

  void clearEmailError() {
    if (emailError.value.isNotEmpty) {
      emailError.value = '';
    }
  }

  void clearPasswordError() {
    if (passwordError.value.isNotEmpty) {
      passwordError.value = '';
    }
  }

  void clearConfirmPasswordError() {
    if (confirmPasswordError.value.isNotEmpty) {
      confirmPasswordError.value = '';
    }
  }

  void clearFirstNameError() {
    if (firstNameError.value.isNotEmpty) {
      firstNameError.value = '';
    }
  }

  void clearLastNameError() {
    if (lastNameError.value.isNotEmpty) {
      lastNameError.value = '';
    }
  }

  void clearPhoneError() {
    if (phoneError.value.isNotEmpty) {
      phoneError.value = '';
    }
  }

  // Validações assíncronas para username e email
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

    // Validação simples de formato
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      emailError.value = 'E-mail inválido';
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

  // Validações síncronas para demais campos
  bool validatePassword(String password) {
    if (password.trim().isEmpty) {
      passwordError.value = 'Informe a senha';
      return false;
    }
    if (password.length < 8) {
      passwordError.value = 'Senha deve ter ao menos 8 caracteres';
      return false;
    }
    passwordError.value = '';
    return true;
  }

  bool validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.trim().isEmpty) {
      confirmPasswordError.value = 'Confirme a senha';
      return false;
    }
    if (password != confirmPassword) {
      confirmPasswordError.value = 'As senhas não conferem';
      return false;
    }
    confirmPasswordError.value = '';
    return true;
  }

  bool validateFirstName(String firstName) {
    if (firstName.trim().isEmpty) {
      firstNameError.value = 'Informe o primeiro nome';
      return false;
    }
    firstNameError.value = '';
    return true;
  }

  bool validateLastName(String lastName) {
    if (lastName.trim().isEmpty) {
      lastNameError.value = 'Informe o sobrenome';
      return false;
    }
    lastNameError.value = '';
    return true;
  }

  bool validatePhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) {
      phoneError.value = 'Informe o telefone';
      return false;
    }
    if (digitsOnly.length < 11) {
      phoneError.value = 'Telefone incompleto';
      return false;
    }
    phoneError.value = '';
    return true;
  }

  // Validação geral de todos os campos antes de salvar
  Future<bool> validateAllFields({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    bool valid = true;

    if (!await validateUsername(username)) valid = false;
    if (!await validateEmail(email)) valid = false;
    if (!validatePassword(password)) valid = false;
    if (!validateConfirmPassword(password, confirmPassword)) valid = false;
    if (!validateFirstName(firstName)) valid = false;
    if (!validateLastName(lastName)) valid = false;
    if (!validatePhone(phone)) valid = false;

    return valid;
  }

  // Métodos para manipulação do usuário no storage
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
