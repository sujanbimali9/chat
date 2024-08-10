import 'package:chat/src/auth/presentation/widgets/login_form_and_icon.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: LoginFormAndIcon(),
      ),
    );
  }
}
