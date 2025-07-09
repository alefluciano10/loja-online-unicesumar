import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../custom/custom.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    if (isLoading.value) return;

    isLoading.value = true;

    final request = LoginRequestModel(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    EasyLoading.show(
      status: 'Entrando...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      await authController.login(request);
      EasyLoading.dismiss();

      if (authController.logado.value) {
        Get.offAllNamed('/');
      } else {
        EasyLoading.showError(
          authController.erro.value.isNotEmpty
              ? authController.erro.value
              : 'Falha ao fazer login.',
        );
      }
    } catch (e) {
      EasyLoading.showError('Erro inesperado. Tente novamente.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Fundo claro
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Color(0xFFFF6B00),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: const Text(
                    'Bem-vindo(a) de volta!',
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
                    'Acesse sua conta para continuar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5F6C7B),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Campo usuário
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: TextFormField(
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: CustomInputDecorations.inputDecoration(
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
                ),
                const SizedBox(height: 16),

                // Campo senha
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword.value,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _login(),
                      decoration:
                          CustomInputDecorations.inputDecoration(
                            'Senha',
                            const Icon(Icons.lock),
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF5F6C7B),
                              ),
                              onPressed: () {
                                obscurePassword.value = !obscurePassword.value;
                              },
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe sua senha';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão Entrar
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: isLoading.value
                            ? const SizedBox.shrink()
                            : const Icon(Icons.login, color: Colors.white),
                        label: isLoading.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading.value ? null : _login,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Link de cadastro
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Não tem uma conta? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5F6C7B),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/signup'),
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: Color(0xFFFF6B00),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
