import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Visibilidade das senhas
  bool showOld = false;
  bool showNew = false;
  bool showConfirm = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authController.changePassword(
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
    );

    if (success) {
      Get.snackbar(
        'Sucesso',
        'Senha alterada com sucesso!',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
      Get.back();
    } else {
      Get.snackbar(
        'Erro',
        authController.erro.value,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  InputDecoration _inputDecoration(
    String label,
    Icon icon, {
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      hintText: label,
      prefixIcon: icon,
      suffixIcon: IconButton(
        icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        onPressed: onToggle,
      ),
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
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alterar Senha')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: !showOld,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    'Senha atual',
                    const Icon(Icons.lock_outline),
                    visible: showOld,
                    onToggle: () => setState(() => showOld = !showOld),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a senha atual';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: !showNew,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    'Nova senha',
                    const Icon(Icons.lock),
                    visible: showNew,
                    onToggle: () => setState(() => showNew = !showNew),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'A nova senha deve ter pelo menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !showConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: _inputDecoration(
                    'Confirmar nova senha',
                    const Icon(Icons.lock_reset),
                    visible: showConfirm,
                    onToggle: () => setState(() => showConfirm = !showConfirm),
                  ),
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Obx(
                  () => ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: authController.carregando.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Salvar nova senha',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 15, 3, 88),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: authController.carregando.value ? null : _submit,
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
