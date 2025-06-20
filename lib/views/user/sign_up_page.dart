// -------------------- SIGNUP PAGE --------------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';
import './../../widgets/widgets.dart';
import './../../models/models.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final UserController usuarioController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final newUser = UserModel(
      id: 0,
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      address: AddressModel(
        city: '',
        street: '',
        number: 0,
        zipcode: '',
        geolocation: GeolocationModel(lat: '', long: ''),
      ),
      name: NameModel(firstname: '', lastname: ''),
      phone: '',
    );

    await usuarioController.saveUser(newUser);

    setState(() => _isLoading = false);

    if (usuarioController.erro.value.isEmpty &&
        usuarioController.user.value != null) {
      Get.snackbar(
        'Cadastro realizado',
        'Sua conta foi criada com sucesso!',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
      Get.offAllNamed('/login');
    } else {
      Get.snackbar(
        'Erro no cadastro',
        usuarioController.erro.value.isNotEmpty
            ? usuarioController.erro.value
            : 'Falha ao criar a conta.',
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
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
        borderRadius: BorderRadius.circular(15),
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
        title: const Text('Criar Conta'),
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
                const SizedBox(height: 15),
                const Icon(Icons.shopping_bag, size: 80, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Seja Bem-vindo(a)!',
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Crie sua conta para começar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),

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

                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: _inputDecoration(
                    'E-mail',
                    const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu e-mail';
                    }
                    if (!GetUtils.isEmail(value.trim())) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  onFieldSubmitted: (_) => _signup(),
                  decoration: _inputDecoration('Senha', const Icon(Icons.lock)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe uma senha';
                    }
                    if (value.trim().length < 8) {
                      return 'A senha deve ter pelo menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add, color: Colors.white),
                    label: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Cadastrar',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 15, 3, 88),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signup,
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Já tem uma conta? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Get.toNamed('/login'),
                      child: const Text(
                        'Entrar',
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
