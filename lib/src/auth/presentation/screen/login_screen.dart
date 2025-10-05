import 'package:chat/core/common/loading/loading_screen.dart';
import 'package:chat/core/routes/app_routes.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/login_form.dart';
import 'package:chat/utils/color/color.dart';
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
        if (state is AuthLoading) {
          LoadingScreen.instance.show(context: context);
        } else {
          LoadingScreen.instance.hide();
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is AuthLoggedIn) {
          context.goToHome(state.user);
        } else if (state is AuthLoggedOut) {
          context.goToLogin();
        } else if (state is AuthResetEmailSent) {
          final email = state.email;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('Mail sent to $email')));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                overscroll: false,
                physics: const ClampingScrollPhysics(),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        SizedBox(
                          height: screenSize.width * 0.3,
                          child: Image.asset(
                            TIcons.chat,
                            color: TColors.primary,
                          ),
                        ),
                        const LoginForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
