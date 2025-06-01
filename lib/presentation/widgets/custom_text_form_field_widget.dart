import 'package:flutter/material.dart';

import '../../style/text_style.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool isPassword;
  final void Function()? onToggleObscure;
  final IconData? prefixIcon;
  final int? maxLength;
  final String? counterText;
  final TextInputType? keyboardType;
  final int? maxLines; // max lines for input
  final int? minLines; // min lines for input

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.isPassword = false,
    this.onToggleObscure,
    this.prefixIcon,
    this.maxLength,
    this.counterText,
    this.maxLines,
    this.minLines,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines ?? 1, // Default to 1 line if not specified
      minLines: minLines,
      keyboardType: keyboardType ??
          (maxLines != null && maxLines! > 1
              ? TextInputType.multiline
              : TextInputType.text),
      textInputAction: (keyboardType == TextInputType.multiline ||
              (maxLines != null && maxLines! > 1))
          ? TextInputAction.newline
          : TextInputAction.done,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTextStyles.regular,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        counterText: counterText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
