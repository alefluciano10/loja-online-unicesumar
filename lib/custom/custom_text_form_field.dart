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
      style: TextStyle(
        fontStyle: FontStyle.normal, // texto digitado normal (sem itálico)
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          fontStyle: FontStyle.normal, // label sempre normal (não itálico)
          color: _hasFocus ? widget.primaryColor : Colors.grey[700],
        ),
        hintText: isEmpty ? widget.label : null,
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic, // hint itálico só se campo vazio
          color: Colors.grey[700],
        ),
        prefixIcon: widget.icon,
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
        errorText: showErrorNow && hasError ? widget.externalError : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }
}
