import 'package:flutter/material.dart';
import 'package:flutter_masked_text3/flutter_masked_text3.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import './../../controllers/controllers.dart';
import './../../models/models.dart';

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
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00)00000-0000');

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

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
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
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

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (isLoading.value) return;

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

    isLoading.value = true;
    EasyLoading.show(
      status: 'Cadastrando...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      final usuarioSalvo = await userController.userRepository.saveUser(
        novoUsuario,
      );
      userController.user.value = usuarioSalvo;

      EasyLoading.showSuccess('Cadastro realizado com sucesso!');
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed('/login');
    } catch (e) {
      EasyLoading.showError('Erro ao cadastrar: $e');
    } finally {
      isLoading.value = false;
    }
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
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.person_add, size: 80, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Crie sua conta!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
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

                TextFormField(
                  controller: _firstnameController,
                  decoration: _inputDecoration(
                    'Primeiro Nome',
                    const Icon(Icons.badge),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Informe o primeiro nome' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _lastnameController,
                  decoration: _inputDecoration(
                    'Sobrenome',
                    const Icon(Icons.badge_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Informe o sobrenome' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration(
                    'Usuário',
                    const Icon(Icons.person),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Informe o username' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration(
                    'Email',
                    const Icon(Icons.email),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe o email';
                    if (!v.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration(
                    'Telefone',
                    const Icon(Icons.phone),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Informe o telefone' : null,
                ),

                const SizedBox(height: 16),

                Obx(
                  () => TextFormField(
                    controller: _passwordController,
                    obscureText: obscurePassword.value,
                    decoration:
                        _inputDecoration(
                          'Senha',
                          const Icon(Icons.lock),
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                obscurePassword.value = !obscurePassword.value,
                          ),
                        ),
                    validator: (v) => v == null || v.length < 8
                        ? 'Senha deve ter ao menos 8 caracteres'
                        : null,
                  ),
                ),
                const SizedBox(height: 24),

                Obx(
                  () => SizedBox(
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
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F0358),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading.value ? null : _onSubmit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
