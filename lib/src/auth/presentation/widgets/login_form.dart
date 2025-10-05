import 'package:chat/core/routes/app_routes.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/auth_button.dart';
import 'package:chat/src/auth/presentation/widgets/auth_input_field.dart';
import 'package:chat/utils/constant/auth_constant.dart';
import 'package:chat/utils/theme/theme.dart';
import 'package:chat/utils/validator/validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

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
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          AuthInputField(
            controller: emailController,
            filled: true,
            label: AuthConstant.email,
            hintText: AuthConstant.email,
            keyboardType: TextInputType.emailAddress,
            validator: TValidator.email,
          ),

          ValueListenableBuilder<bool>(
            valueListenable: hidePassword,
            builder: (context, isHidden, child) {
              return AuthInputField(
                controller: passwordController,
                filled: true,
                label: AuthConstant.password,
                hintText: AuthConstant.password,
                obscureText: isHidden,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => TValidator.validate('Password', value),
                suffixIcon: IconButton(
                  icon: Icon(
                    isHidden
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                  onPressed: () async {
                    hidePassword.value = !hidePassword.value;
                  },
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                text: 'Forget password?',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    context.pushForgetPassword();
                  },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: AuthButton(
              text: AuthConstant.login,
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                context.read<AuthBloc>().add(
                  EmailLogin(emailController.text, passwordController.text),
                );
              },
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: TTheme.isDarkMode ? Colors.white54 : Colors.black54,
                ),
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.pushSignUp();
                      },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
