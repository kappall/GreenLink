import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final Color? backgroundColor;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscure = false,
    this.backgroundColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscure,
      textInputAction: TextInputAction.done,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class ObscurableAuthTextField extends AuthTextField {
  const ObscurableAuthTextField({
    super.key,
    required super.hint,
    required super.controller,
  });
}
