import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text3/flutter_masked_text3.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:animate_do/animate_do.dart';

import './../../controllers/controllers.dart';
import './../../models/models.dart';
import './../../custom/custom.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final UserController userController = Get.find<UserController>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00)00000-0000');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  final RxString emailFormatError = ''.obs;
  final RxString phoneFormatError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;
  final RxString firstNameError = ''.obs;
  final RxString lastNameError = ''.obs;

  final RxBool _formSubmitted = false.obs;

  Timer? _usernameDebounce;
  Timer? _emailDebounce;

  final Color primaryColor = const Color(0xFFFF6B00);
  final Color accentColor = const Color(0xFF344055);

  @override
  void initState() {
    super.initState();

    userController.clearUsernameError();
    userController.clearEmailError();

    _usernameController.addListener(() {
      if (_usernameDebounce?.isActive ?? false) _usernameDebounce!.cancel();
      _usernameDebounce = Timer(const Duration(milliseconds: 500), () {
        if (_usernameController.text.trim().isNotEmpty) {
          userController.validateUsername(_usernameController.text.trim());
        }
      });

      if (userController.usernameError.value.isNotEmpty &&
          _usernameController.text.trim().isNotEmpty) {
        userController.clearUsernameError();
      }
    });

    _emailController.addListener(() {
      if (_emailDebounce?.isActive ?? false) _emailDebounce!.cancel();
      _emailDebounce = Timer(const Duration(milliseconds: 500), () {
        if (_emailController.text.trim().isNotEmpty) {
          userController.validateEmail(_emailController.text.trim());
        }
      });

      final email = _emailController.text.trim();
      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

      if (email.isEmpty || emailRegex.hasMatch(email)) {
        emailFormatError.value = '';
      }

      if (userController.emailError.value.isNotEmpty && email.isNotEmpty) {
        userController.clearEmailError();
      }
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        final email = _emailController.text.trim();
        final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
        if (email.isNotEmpty && !emailRegex.hasMatch(email)) {
          emailFormatError.value = 'E-mail inválido';
        }
      }
    });

    _phoneController.addListener(() {
      if (_phoneFocusNode.hasFocus && phoneFormatError.isNotEmpty) {
        phoneFormatError.value = '';
      }
    });

    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        final digitsOnly = _phoneController.text.replaceAll(RegExp(r'\D'), '');
        if (_phoneController.text.isNotEmpty && digitsOnly.length < 11) {
          phoneFormatError.value = 'Telefone incompleto';
        }
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        passwordError.value = '';
      } else {
        final senha = _passwordController.text;

        if (!_formSubmitted.value) {
          if (senha.isNotEmpty && senha.length < 8) {
            passwordError.value = 'Senha deve ter ao menos 8 caracteres';
          } else {
            passwordError.value = '';
          }
        } else {
          if (senha.isEmpty) {
            passwordError.value = 'Informe a senha';
          } else if (senha.length < 8) {
            passwordError.value = 'Senha deve ter ao menos 8 caracteres';
          } else {
            passwordError.value = '';
          }
        }
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if (_confirmPasswordFocusNode.hasFocus) {
        confirmPasswordError.value = '';
      } else {
        final confirm = _confirmPasswordController.text;
        final senha = _passwordController.text;

        if (!_formSubmitted.value) {
          if (confirm.isNotEmpty && confirm != senha) {
            confirmPasswordError.value = 'As senhas não conferem';
          } else {
            confirmPasswordError.value = '';
          }
        } else {
          if (confirm.isEmpty) {
            confirmPasswordError.value = 'Confirme a senha';
          } else if (confirm != senha) {
            confirmPasswordError.value = 'As senhas não conferem';
          } else {
            confirmPasswordError.value = '';
          }
        }
      }
    });

    _firstnameController.addListener(() {
      if (firstNameError.isNotEmpty && _firstnameController.text.isNotEmpty) {
        firstNameError.value = '';
      }
    });

    _lastnameController.addListener(() {
      if (lastNameError.isNotEmpty && _lastnameController.text.isNotEmpty) {
        lastNameError.value = '';
      }
    });
  }

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _emailDebounce?.cancel();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _validateAsyncFields() async {
    if (_usernameController.text.trim().isNotEmpty) {
      await userController.validateUsername(_usernameController.text.trim());
    }
    if (_emailController.text.trim().isNotEmpty) {
      await userController.validateEmail(_emailController.text.trim());
    }
    return userController.usernameError.value.isEmpty &&
        userController.emailError.value.isEmpty;
  }

  Future<void> _onSubmit() async {
    if (isLoading.value) return;

    _formSubmitted.value = true; // ativa flag para mostrar erros

    bool validSync = true;

    if (_firstnameController.text.trim().isEmpty) {
      firstNameError.value = 'Informe o primeiro nome';
      validSync = false;
    }
    if (_lastnameController.text.trim().isEmpty) {
      lastNameError.value = 'Informe o sobrenome';
      validSync = false;
    }
    if (_usernameController.text.trim().isEmpty) {
      userController.usernameError.value = 'Informe o nome de usuário';
      validSync = false;
    }
    if (_emailController.text.trim().isEmpty) {
      userController.emailError.value = 'Informe o e-mail';
      validSync = false;
    }
    final phoneDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (_phoneController.text.trim().isEmpty || phoneDigits.length < 11) {
      phoneFormatError.value = _phoneController.text.trim().isEmpty
          ? 'Informe o telefone'
          : 'Telefone incompleto';
      validSync = false;
    }
    if (_passwordController.text.trim().isEmpty) {
      passwordError.value = 'Informe a senha';
      validSync = false;
    } else if (_passwordController.text.trim().length < 8) {
      passwordError.value = 'Senha deve ter ao menos 8 caracteres';
      validSync = false;
    }
    if (_confirmPasswordController.text.trim().isEmpty) {
      confirmPasswordError.value = 'Confirme a senha';
      validSync = false;
    } else if (_confirmPasswordController.text.trim() !=
        _passwordController.text.trim()) {
      confirmPasswordError.value = 'As senhas não conferem';
      validSync = false;
    }

    if (!validSync) {
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(
          title: 'Erro no cadastro',
          subtitle: 'Preencha todos os campos obrigatórios corretamente.',
          buttonLabel: 'Fechar',
          onConfirm: () => Get.back(),
        ),
      );
      return;
    }

    final validAsync = await _validateAsyncFields();
    if (!validAsync) {
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(
          title: 'Erro no cadastro',
          subtitle: 'Usuário ou e-mail já cadastrados.',
          buttonLabel: 'Fechar',
          onConfirm: () => Get.back(),
        ),
      );
      return;
    }

    isLoading.value = true;
    EasyLoading.show(status: 'Cadastrando...');

    try {
      final novoUsuario = UserModel(
        id: 0,
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: UserModel.hashPassword(_passwordController.text.trim()),
        name: NameModel(
          firstname: _firstnameController.text.trim(),
          lastname: _lastnameController.text.trim(),
        ),
        phone: _phoneController.text.trim(),
        address: AddressModel(
          city: '',
          street: '',
          number: 0,
          zipcode: '',
          geolocation: GeolocationModel(lat: '', long: ''),
        ),
      );

      final usuarioSalvo = await userController.userRepository.saveUser(
        novoUsuario,
      );
      userController.user.value = usuarioSalvo;

      await Future.delayed(const Duration(seconds: 2));
      Get.dialog(
        SuccessDialog(
          title: 'Cadastro realizado!',
          subtitle: 'Seu cadastro foi concluído com sucesso.',
          buttonLabel: 'Ir para o login',
          onConfirm: () => Get.offAllNamed('/login'),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(
          title: 'Erro ao cadastrar',
          subtitle: 'Não foi possível completar o cadastro. Tente novamente.',
          buttonLabel: 'Fechar',
          onConfirm: () => Get.back(),
        ),
      );
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Widget _buildFirstNameField() => Obx(() {
    return CustomTextFormField(
      controller: _firstnameController,
      label: 'Primeiro Nome',
      icon: const Icon(Icons.badge),
      externalError: firstNameError.value.isNotEmpty
          ? firstNameError.value
          : null,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      primaryColor: primaryColor,
    );
  });

  Widget _buildLastNameField() => Obx(() {
    return CustomTextFormField(
      controller: _lastnameController,
      label: 'Sobrenome',
      icon: const Icon(Icons.badge_outlined),
      externalError: lastNameError.value.isNotEmpty
          ? lastNameError.value
          : null,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      primaryColor: primaryColor,
    );
  });

  Widget _buildUsernameField() => Obx(() {
    final error = userController.usernameError.value;
    return CustomTextFormField(
      controller: _usernameController,
      label: 'Usuário',
      icon: const Icon(Icons.person),
      externalError: error.isNotEmpty ? error : null,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      primaryColor: primaryColor,
    );
  });

  Widget _buildEmailField() => Obx(() {
    final error = userController.emailError.value.isNotEmpty
        ? userController.emailError.value
        : emailFormatError.value;
    return CustomTextFormField(
      controller: _emailController,
      label: 'E-mail',
      icon: const Icon(Icons.email),
      keyboardType: TextInputType.emailAddress,
      externalError: error.isNotEmpty ? error : null,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      focusNode: _emailFocusNode,
      primaryColor: primaryColor,
    );
  });

  Widget _buildPhoneField() => Obx(() {
    final error = phoneFormatError.value;
    return CustomTextFormField(
      controller: _phoneController,
      label: 'Telefone',
      icon: const Icon(Icons.phone),
      keyboardType: TextInputType.phone,
      externalError: error.isNotEmpty ? error : null,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
      focusNode: _phoneFocusNode,
      primaryColor: primaryColor,
    );
  });

  Widget _buildPasswordField() => Obx(() {
    return CustomTextFormField(
      controller: _passwordController,
      label: 'Senha',
      icon: const Icon(Icons.lock),
      obscureText: obscurePassword.value,
      suffixIcon: IconButton(
        icon: Icon(
          obscurePassword.value ? Icons.visibility_off : Icons.visibility,
          color: Color(0xFF5F6C7B),
        ),
        onPressed: () => obscurePassword.value = !obscurePassword.value,
      ),
      externalError: passwordError.value.isNotEmpty
          ? passwordError.value
          : null,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
      focusNode: _passwordFocusNode,
      primaryColor: primaryColor,
    );
  });

  Widget _buildConfirmPasswordField() => Obx(() {
    final error = confirmPasswordError.value;
    return CustomTextFormField(
      controller: _confirmPasswordController,
      label: 'Confirmar Senha',
      icon: const Icon(Icons.lock_outline),
      obscureText: obscureConfirmPassword.value,
      suffixIcon: IconButton(
        icon: Icon(
          obscureConfirmPassword.value
              ? Icons.visibility_off
              : Icons.visibility,
          color: Color(0xFF5F6C7B),
        ),
        onPressed: () =>
            obscureConfirmPassword.value = !obscureConfirmPassword.value,
      ),
      externalError: error.isNotEmpty ? error : null,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onSubmit(),
      focusNode: _confirmPasswordFocusNode,
      primaryColor: primaryColor,
    );
  });

  Widget _buildSubmitButton() => Obx(() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: isLoading.value
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.check_circle, color: Colors.white),
        label: Text(
          isLoading.value ? 'Cadastrando...' : 'Cadastrar',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading.value ? null : _onSubmit,
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Icon(Icons.person_add, size: 80, color: primaryColor),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  'Crie sua conta!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF344055),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: const Text(
                  'Preencha seus dados para continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5F6C7B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    Expanded(child: _buildFirstNameField()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildLastNameField()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: _buildUsernameField(),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: _buildEmailField(),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: _buildPhoneField(),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 900),
                child: _buildPasswordField(),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: _buildConfirmPasswordField(),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                delay: const Duration(milliseconds: 1100),
                child: _buildSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
