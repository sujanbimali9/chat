import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/social_icon.dart';
import 'package:chat/utils/color/color.dart';
import 'package:chat/utils/constant/auth_constant.dart';
import 'package:chat/utils/constant/routes.dart';
import 'package:chat/utils/icons/assetsicons.dart';
import 'package:chat/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final formKey = GlobalKey<FormState>();
  late final ValueNotifier<bool> hidePassword;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    hidePassword = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState?.dispose();
    hidePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            AuthConstant.email,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: emailController,
            validator: TValidator.email,
          ),
          const SizedBox(height: 20),
          Text(AuthConstant.password,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ValueListenableBuilder<bool>(
            valueListenable: hidePassword,
            builder: (context, isHidden, child) {
              return TextFormField(
                controller: passwordController,
                validator: (value) => TValidator.validate('Password', value),
                obscureText: isHidden,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(isHidden
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded),
                    onPressed: () async {
                      hidePassword.value = !hidePassword.value;
                    },
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.signUp);
                },
                child: const Text(
                  'Don\'t have a account?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                  style: TextButton.styleFrom(
                      overlayColor: const Color.fromARGB(0, 209, 154, 154)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.forgetPassword);
                  },
                  child: const Text('forget password?')),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                context.read<AuthBloc>().add(EmailLogin(
                      emailController.text,
                      passwordController.text,
                    ));
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text(AuthConstant.login),
            ),
          ),
          const SizedBox(height: 30),
          const Row(
            children: [
              Expanded(child: Divider(indent: 10, endIndent: 10)),
              Text(AuthConstant.orSignInWith),
              Expanded(child: Divider(indent: 10, endIndent: 10)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TSocialMediaButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(GoogleLogin());
                },
                icon: TIcons.google,
              ),
              const SizedBox(width: 20),
              TSocialMediaButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(FacebookLogin());
                },
                icon: TIcons.facebook,
                iconColor: TColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
