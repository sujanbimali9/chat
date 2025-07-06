import 'package:chat/core/common/loading/loading_screen.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:chat/utils/color/color.dart';
import 'package:chat/utils/constant/routes.dart';
import 'package:chat/utils/icons/assetsicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          LoadingScreen.instance.show(context: context);
        } else {
          LoadingScreen.instance.hide();
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }

        if (state is AuthLoggedIn) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.home, (route) => false,
              arguments: state.user);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: screenSize.width * 0.3,
                      child: Image.asset(
                        TIcons.chat,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                  const SignUpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
