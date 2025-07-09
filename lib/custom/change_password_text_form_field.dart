import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final RxString error;
  final RxBool valid;
  final bool showPassword;
  final VoidCallback onToggle;
  final TextInputAction textInputAction;
  final Function(String)? onFieldSubmitted;

  const CustomPasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.error,
    required this.valid,
    required this.showPassword,
    required this.onToggle,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFF5F6C7B);

    Widget suffixIcons() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (error.value.isNotEmpty) {
              return const Icon(Icons.error, color: Colors.red);
            } else if (valid.value) {
              return const Icon(Icons.check_circle, color: Colors.green);
            }
            return const SizedBox.shrink();
          }),
          Tooltip(
            message: showPassword ? 'Ocultar senha' : 'Mostrar senha',
            child: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
                color: baseColor,
              ),
              onPressed: onToggle,
              splashRadius: 22,
            ),
          ),
        ],
      );
    }

    return Obx(
      () => TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: !showPassword,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF344055),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF5F6C7B)),
          suffixIcon: suffixIcons(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade700, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade700, width: 2.5),
          ),
          errorText: error.value.isNotEmpty ? error.value : null,
          hintText: label,
          hintStyle: const TextStyle(
            color: Color(0xFFA0AAB4),
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
