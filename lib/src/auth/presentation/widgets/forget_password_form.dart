import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({super.key});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
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
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: 16, color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('Email'),
            const SizedBox(height: 8),
            TextFormField(validator: TValidator.email),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 206, 204, 204),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  context
                      .read<AuthBloc>()
                      .add(ResetPassword(emailController.text.trim()));
                },
                child: const Text('SendResetLink'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
