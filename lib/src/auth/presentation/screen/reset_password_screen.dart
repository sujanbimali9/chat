import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/forget_password_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(),
        resizeToAvoidBottomInset: true,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ResetPasswordForm(),
          ),
        ),
      ),
    );
  }
}
