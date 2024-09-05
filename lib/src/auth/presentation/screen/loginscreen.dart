import 'package:chat/core/common/loading/loading_screen.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/login_form.dart';
import 'package:chat/src/home/presentation/bloc/home_bloc.dart';
import 'package:chat/utils/color/color.dart';
import 'package:chat/utils/constant/routes.dart';
import 'package:chat/utils/icons/assetsicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {}
        if (state is AuthLoading) {
          LoadingScreen.instance().show(context: context);
        } else {
          LoadingScreen.instance().hide();
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }

        if (state is AuthLoggedIn) {
          if (state.mode != null) {
            context.read<HomeBloc>().add(const CreateUser());
          }

          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.home, (route) => false);
        } else if (state is AuthEmailUnVerified) {
          context.read<HomeBloc>().add(const CreateUser());
          Navigator.of(context)
              .pushNamed(Routes.signUpVerify, arguments: state.email);
        } else if (state is AuthEmailVerified) {
          Navigator.of(context).pushNamed(Routes.login);
        } else if (state is AuthLoggedOut) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.login, (route) => false);
        } else if (state is AuthEmailResendVerification ||
            state is AuthPasswordResetResend) {
          final email = state is AuthEmailResendVerification
              ? state.email
              : (state as AuthPasswordResetResend).email;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Mail sent to $email'),
              ),
            );
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
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
