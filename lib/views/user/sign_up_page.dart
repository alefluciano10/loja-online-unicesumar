import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text3/flutter_masked_text3.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import './../../controllers/controllers.dart';
import './../../models/models.dart';
import './../../custom/sucess_dialog.dart';
import './../../custom/error_dialog.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final UserController userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00)00000-0000');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  // Novo FocusNode para o campo senha
  final FocusNode _passwordFocusNode = FocusNode();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  final RxString emailFormatError = ''.obs;
  final RxString phoneFormatError = ''.obs;

  // Nova RxString para o erro da senha
  final RxString passwordError = ''.obs;

  Timer? _usernameDebounce;
  Timer? _emailDebounce;

  final Color primaryColor = const Color(0xFF0F0358);
  final Color accentColor = Colors.orange;

  bool _formSubmitted = false;

  @override
  void initState() {
    super.initState();

    // RESET ao abrir a tela para limpar erros e evitar campos vermelhos indesejados
    _formSubmitted = false;
    userController.clearUsernameError();
    userController.clearEmailError();
    emailFormatError.value = '';
    phoneFormatError.value = '';
    passwordError.value = '';

    _usernameController.addListener(() {
      if (_usernameDebounce?.isActive ?? false) _usernameDebounce!.cancel();
      _usernameDebounce = Timer(const Duration(milliseconds: 500), () {
        if (_usernameController.text.trim().isNotEmpty) {
          userController.validateUsername(_usernameController.text.trim());
        }
      });
      if (userController.usernameError.value.isNotEmpty) {
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

      if (userController.emailError.value.isNotEmpty) {
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
      final digitsOnly = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      if (phoneFormatError.isNotEmpty &&
          (digitsOnly.isEmpty || digitsOnly.length >= 11)) {
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

    // Listener do FocusNode para o campo senha
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        final senha = _passwordController.text;
        if (senha.length < 8 && senha.isNotEmpty) {
          passwordError.value = 'Senha deve ter ao menos 8 caracteres';
        }
      }
    });

    // Listener para limpar erro ao digitar senha válida ou limpar
    _passwordController.addListener(() {
      final senha = _passwordController.text;
      if (passwordError.isNotEmpty) {
        if (senha.isEmpty || senha.length >= 8) {
          passwordError.value = '';
        }
      }
      setState(() {}); // atualiza visibilidade do ícone, etc
    });

    _firstnameController.addListener(() => setState(() {}));
    _lastnameController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
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

    super.dispose();
  }

  InputDecoration _inputDecoration(String label, Icon icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      hintText: label,
      prefixIcon: icon,
      hintStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
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

    setState(() {
      _formSubmitted = true;
    });

    bool validSync = _formKey.currentState!.validate();

    if (_usernameController.text.trim().isEmpty) {
      userController.usernameError.value = 'Informe o nome de usuário';
      validSync = false;
    }
    if (_emailController.text.trim().isEmpty) {
      userController.emailError.value = 'Informe o e-mail';
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

    bool validAsync = await _validateAsyncFields();

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

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstnameController,
      decoration: _inputDecoration('Primeiro Nome', const Icon(Icons.badge)),
      validator: (v) {
        if (!_formSubmitted) return null;
        return v == null || v.isEmpty ? 'Informe o primeiro nome' : null;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastnameController,
      decoration: _inputDecoration(
        'Sobrenome',
        const Icon(Icons.badge_outlined),
      ),
      validator: (v) {
        if (!_formSubmitted) return null;
        return v == null || v.isEmpty ? 'Informe o sobrenome' : null;
      },
    );
  }

  Widget _buildUsernameField() {
    return Obx(() {
      final error = userController.usernameError.value;
      return TextFormField(
        controller: _usernameController,
        decoration: _inputDecoration(
          'Usuário',
          const Icon(Icons.person),
        ).copyWith(errorText: error.isEmpty ? null : error),
        validator: (v) {
          if (!_formSubmitted) return null;
          if (v == null || v.trim().isEmpty) {
            return 'Informe o nome de usuário';
          }
          return null;
        },
      );
    });
  }

  Widget _buildEmailField() {
    return Obx(() {
      final controllerError = userController.emailError.value;
      final localError = emailFormatError.value;

      return TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: _inputDecoration('Email', const Icon(Icons.email)).copyWith(
          errorText: localError.isNotEmpty
              ? localError
              : (controllerError.isNotEmpty ? controllerError : null),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (!_formSubmitted) return null;
          if (value == null || value.trim().isEmpty) return 'Informe o e-mail';
          if (localError.isNotEmpty) return localError;
          if (controllerError.isNotEmpty) return controllerError;
          return null;
        },
      );
    });
  }

  Widget _buildPhoneField() {
    return Obx(() {
      final localError = phoneFormatError.value;

      return TextFormField(
        controller: _phoneController,
        focusNode: _phoneFocusNode,
        decoration: _inputDecoration(
          'Telefone',
          const Icon(Icons.phone),
        ).copyWith(errorText: localError.isNotEmpty ? localError : null),
        keyboardType: TextInputType.phone,
        validator: (v) {
          if (!_formSubmitted) return null;
          if (v == null || v.isEmpty) return 'Informe o telefone';
          final digitsOnly = v.replaceAll(RegExp(r'\D'), '');
          if (digitsOnly.length < 11) return 'Telefone incompleto';
          return null;
        },
      );
    });
  }

  Widget _buildPasswordField() {
    return Obx(() {
      return TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: obscurePassword.value,
        decoration: _inputDecoration('Senha', const Icon(Icons.lock)).copyWith(
          errorText: passwordError.value.isNotEmpty
              ? passwordError.value
              : null,
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword.value ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => obscurePassword.value = !obscurePassword.value,
          ),
        ),
        validator: (v) {
          if (!_formSubmitted) return null;
          if (v == null || v.length < 8) {
            return 'Senha deve ter ao menos 8 caracteres';
          }
          return null;
        },
      );
    });
  }

  Widget _buildConfirmPasswordField() {
    return Obx(() {
      return TextFormField(
        controller: _confirmPasswordController,
        obscureText: obscureConfirmPassword.value,
        decoration:
            _inputDecoration(
              'Confirmar Senha',
              const Icon(Icons.lock_outline),
            ).copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirmPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () => obscureConfirmPassword.value =
                    !obscureConfirmPassword.value,
              ),
            ),
        validator: (v) {
          if (!_formSubmitted) return null;
          if (v == null || v.isEmpty) return 'Confirme a senha';
          if (v != _passwordController.text) return 'As senhas não conferem';
          if (v.length < 8) return 'Senha deve ter ao menos 8 caracteres';
          return null;
        },
      );
    });
  }

  Widget _buildSubmitButton() {
    return Obx(() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: _formSubmitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Icon(Icons.person_add, size: 80, color: accentColor),
                const SizedBox(height: 16),
                Text(
                  'Crie sua conta!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Preencha seus dados para continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),
                _buildFirstNameField(),
                const SizedBox(height: 16),
                _buildLastNameField(),
                const SizedBox(height: 16),
                _buildUsernameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
