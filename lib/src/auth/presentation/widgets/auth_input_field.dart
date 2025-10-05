import 'package:chat/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool filled;
  const AuthInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: TTheme.isDarkMode
            ? const Color.fromARGB(90, 55, 65, 81)
            : const Color.fromARGB(90, 45, 43, 43),
      ),
    );
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontSize: 17),
        ),
        TextFormField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          textCapitalization: keyboardType == TextInputType.name
              ? TextCapitalization.words
              : TextCapitalization.none,
          inputFormatters: [
            if (keyboardType == TextInputType.phone)
              FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 17,
            ),
            filled: filled,
            fillColor: TTheme.isDarkMode
                ? const Color.fromARGB(255, 30, 41, 59)
                : const Color.fromARGB(57, 0, 0, 0),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 7, 66, 138),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
