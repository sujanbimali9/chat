import 'package:chat/core/common/loading/loading_screen.dart';
import 'package:chat/core/routes/app_routes.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                overscroll: false,
                physics: const ClampingScrollPhysics(),
              ),
              child: const CustomScrollView(
                slivers: [
                  SliverAppBar(),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: SignUpForm(),
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
