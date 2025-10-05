import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;
  const AuthButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isEnabled ? onPressed : null,
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        minimumSize: const Size(double.infinity, 60),
        maximumSize: const Size(double.infinity, 60),
        backgroundColor: isEnabled
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
      ),
    );
  }
}
