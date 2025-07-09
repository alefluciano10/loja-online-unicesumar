import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../../custom/custom.dart';

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

  final oldPasswordFocus = FocusNode();
  final newPasswordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  final oldPasswordError = ''.obs;
  final oldPasswordValid = false.obs;

  final newPasswordError = ''.obs;
  final newPasswordValid = false.obs;

  final confirmPasswordError = ''.obs;
  final confirmPasswordValid = false.obs;

  bool showOld = false;
  bool showNew = false;
  bool showConfirm = false;
  bool formSubmitted = false;

  @override
  void initState() {
    super.initState();

    oldPasswordFocus.addListener(() {
      if (oldPasswordFocus.hasFocus) {
        oldPasswordError.value = '';
        oldPasswordValid.value = false;
      } else {
        _validateOldPassword();
      }
    });

    newPasswordFocus.addListener(() {
      if (newPasswordFocus.hasFocus) {
        newPasswordError.value = '';
        newPasswordValid.value = false;
      } else {
        _validateNewPassword();
        _validateConfirmPassword();
      }
    });

    confirmPasswordFocus.addListener(() {
      if (confirmPasswordFocus.hasFocus) {
        confirmPasswordError.value = '';
        confirmPasswordValid.value = false;
      } else {
        _validateConfirmPassword();
      }
    });

    newPasswordController.addListener(() {
      setState(() {}); // Atualiza barra de força da senha
      if (!confirmPasswordFocus.hasFocus) {
        _validateConfirmPassword();
      }
    });
  }

  int _passwordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    return strength;
  }

  Color _strengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade700;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _strengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Senha fraca';
      case 2:
        return 'Senha média';
      case 3:
        return 'Senha boa';
      case 4:
        return 'Senha forte';
      default:
        return '';
    }
  }

  Widget _passwordStrengthBar() {
    final password = newPasswordController.text.trim();
    final strength = _passwordStrength(password);
    final color = _strengthColor(strength);
    final text = _strengthText(strength);

    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: strength / 4,
          backgroundColor: Colors.grey.shade300,
          color: color,
          minHeight: 6,
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _validateOldPassword() {
    final value = oldPasswordController.text.trim();

    if (value.isEmpty) {
      oldPasswordError.value = formSubmitted ? 'Informe a senha atual' : '';
      oldPasswordValid.value = false;
    } else {
      oldPasswordError.value = '';
      oldPasswordValid.value = true;
    }
  }

  void _validateNewPassword() {
    final value = newPasswordController.text.trim();

    if (value.isEmpty) {
      newPasswordError.value = formSubmitted ? 'Informe a nova senha' : '';
      newPasswordValid.value = false;
    } else if (value.length < 8) {
      newPasswordError.value = 'A nova senha deve ter pelo menos 8 caracteres';
      newPasswordValid.value = false;
    } else {
      newPasswordError.value = '';
      newPasswordValid.value = true;
    }
  }

  void _validateConfirmPassword() {
    final value = confirmPasswordController.text.trim();

    if (value.isEmpty) {
      confirmPasswordError.value = formSubmitted ? 'Confirme a nova senha' : '';
      confirmPasswordValid.value = false;
    } else if (value != newPasswordController.text.trim()) {
      confirmPasswordError.value = 'As senhas não coincidem';
      confirmPasswordValid.value = false;
    } else {
      confirmPasswordError.value = '';
      confirmPasswordValid.value = true;
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    oldPasswordFocus.dispose();
    newPasswordFocus.dispose();
    confirmPasswordFocus.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      formSubmitted = true;
    });

    _validateOldPassword();
    _validateNewPassword();
    _validateConfirmPassword();

    if (!oldPasswordValid.value ||
        !newPasswordValid.value ||
        !confirmPasswordValid.value) {
      return;
    }

    final success = await authController.changePassword(
      oldPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => SuccessDialog(
          title: 'Senha alterada',
          subtitle:
              'Sua senha foi atualizada com sucesso.\nFaça login novamente.',
          buttonLabel: 'OK',
          onConfirm: () {
            Navigator.of(context).pop();
            authController.logout();
            Get.offAllNamed('/login');
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(
          title: 'Erro ao alterar senha',
          subtitle: authController.erro.value,
          buttonLabel: 'Tentar novamente',
          onConfirm: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  Widget _buildOldPasswordField() {
    return CustomPasswordField(
      label: 'Senha atual',
      controller: oldPasswordController,
      focusNode: oldPasswordFocus,
      error: oldPasswordError,
      valid: oldPasswordValid,
      showPassword: showOld,
      onToggle: () => setState(() => showOld = !showOld),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildNewPasswordField() {
    return CustomPasswordField(
      label: 'Nova senha',
      controller: newPasswordController,
      focusNode: newPasswordFocus,
      error: newPasswordError,
      valid: newPasswordValid,
      showPassword: showNew,
      onToggle: () => setState(() => showNew = !showNew),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomPasswordField(
      label: 'Confirmar nova senha',
      controller: confirmPasswordController,
      focusNode: confirmPasswordFocus,
      error: confirmPasswordError,
      valid: confirmPasswordValid,
      showPassword: showConfirm,
      onToggle: () => setState(() => showConfirm = !showConfirm),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submit(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF5F6C7B)),
        title: const Text(
          'Alterar Senha',
          style: TextStyle(
            color: Color(0xFF5F6C7B),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Form(
            key: _formKey,
            autovalidateMode: formSubmitted
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Color(0xFFFF6B00),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Alterar sua senha',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF344055),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),

                _buildOldPasswordField(),
                const SizedBox(height: 16),

                _buildNewPasswordField(),
                const SizedBox(height: 8),
                _passwordStrengthBar(),
                const SizedBox(height: 16),

                _buildConfirmPasswordField(),
                const SizedBox(height: 32),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: authController.carregando.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save, color: Colors.white),
                      label: authController.carregando.value
                          ? const SizedBox.shrink()
                          : const Text(
                              'Salvar nova senha',
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
                      onPressed: authController.carregando.value
                          ? null
                          : _submit,
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
