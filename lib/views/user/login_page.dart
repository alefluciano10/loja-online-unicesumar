// -------------------- LOGIN PAGE --------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';
import './../../widgets/widgets.dart';
import './../../models/models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final request = LoginRequestModel(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    await authController.login(request);

    if (authController.logado.value) {
      Get.offAllNamed('/');
    } else {
      Get.snackbar(
        'Erro de login',
        authController.erro.value.isNotEmpty
            ? authController.erro.value
            : 'Falha ao fazer login.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    }
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
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.shopping_bag, size: 80, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Bem-vindo(a) de volta!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Acesse sua conta para continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),

                // Username
                TextFormField(
                  controller: usernameController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  decoration: _inputDecoration(
                    'Usuário',
                    const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome de usuário';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _login(),
                  decoration: _inputDecoration('Senha', const Icon(Icons.lock)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                Obx(
                  () => LoadingButton(
                    width: double.infinity,
                    height: 50,
                    text: 'Entrar',
                    icon: Icons.login,
                    backgroundColor: Color.fromARGB(255, 15, 3, 88),
                    isLoading: authController.carregando.value,
                    onPressed: _login,
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () => Get.toNamed('/signup'),
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color.fromARGB(255, 17, 2, 134),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                PrimaryButton(
                  text: 'Continuar comprando',
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () => Get.offAllNamed('/'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
