import 'package:flutter/material.dart';

class CustomInputDecorations {
  static InputDecoration inputDecoration(String label, Icon icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F7FA), // Cinza claro
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF344055), // Azul grafite
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      hintText: label,
      hintStyle: const TextStyle(
        color: Color(0xFFA0AAB4),
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
      prefixIcon: IconTheme(
        data: const IconThemeData(color: Color(0xFF5F6C7B)),
        child: icon,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }
}
