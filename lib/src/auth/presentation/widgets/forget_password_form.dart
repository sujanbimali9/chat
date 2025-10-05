import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/auth_button.dart';
import 'package:chat/src/auth/presentation/widgets/auth_input_field.dart';
import 'package:chat/utils/theme/theme.dart';
import 'package:chat/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  late final TextEditingController emailController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: DefaultTextStyle(
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(fontSize: 16, color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Password',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Enter your email associated with your account and we will send you a email with instruction to reset your password.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: TTheme.isDarkMode ? Colors.white54 : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            AuthInputField(
              controller: emailController,
              filled: true,
              label: 'Email',
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              validator: TValidator.email,
            ),

            const Spacer(),
            AuthButton(
              text: 'Send Reset Link',
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                context.read<AuthBloc>().add(
                  ResetPassword(emailController.text.trim()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
