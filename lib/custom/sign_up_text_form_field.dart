import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Icon icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final Color primaryColor;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? externalError;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    required this.primaryColor,
    this.suffixIcon,
    this.obscureText = false,
    this.externalError,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _hasFocus = false;
  bool _wasFocusedAtLeastOnce = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
        if (!_hasFocus) _wasFocusedAtLeastOnce = true;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError =
        widget.externalError != null && widget.externalError!.isNotEmpty;
    final isValid = !hasError && widget.controller.text.isNotEmpty;

    final showErrorNow = !_hasFocus && (_wasFocusedAtLeastOnce || hasError);

    final bool isEmpty = widget.controller.text.isEmpty;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      focusNode: _focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: const TextStyle(
        fontStyle: FontStyle.normal,
        color: Color(0xFF344055), // texto azul grafite igual label
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F7FA), // fundo cinza claro igual login
        labelText: widget.label,
        labelStyle: TextStyle(
          fontStyle: FontStyle.normal,
          color: _hasFocus ? Colors.indigo : const Color(0xFF344055),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        hintText: isEmpty ? widget.label : null,
        hintStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Color(0xFFA0AAB4),
          fontSize: 14,
        ),
        prefixIcon: IconTheme(
          data: const IconThemeData(color: Color(0xFF5F6C7B)),
          child: widget.icon,
        ),
        suffixIcon:
            widget.suffixIcon ??
            (showErrorNow
                ? (hasError
                      ? const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.error, color: Colors.red),
                        )
                      : isValid
                      ? const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.check_circle, color: Colors.green),
                        )
                      : null)
                : null),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.grey.shade300,
            width: 1.8,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        errorText: showErrorNow ? widget.externalError : null,
      ),
      validator: widget.validator,
    );
  }
}
