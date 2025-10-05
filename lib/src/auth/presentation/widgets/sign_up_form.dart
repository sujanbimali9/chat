import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/auth_button.dart';
import 'package:chat/src/auth/presentation/widgets/auth_input_field.dart';
import 'package:chat/utils/constant/auth_constant.dart';
import 'package:chat/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController name;
  late final TextEditingController phoneNumberController;
  final formKey = GlobalKey<FormState>();
  late final ValueNotifier<bool> hidePassword;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    name = TextEditingController();
    phoneNumberController = TextEditingController();
    hidePassword = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    name.dispose();
    phoneNumberController.dispose();
    formKey.currentState?.dispose();
    hidePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 13,
          children: [
            Text(
              'Create Your Account',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AuthInputField(
              hintText: 'Enter your full name',
              label: AuthConstant.fullName,
              keyboardType: TextInputType.name,

              controller: name,
              validator: (value) => TValidator.validate('Full Name', value),
            ),
            AuthInputField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: TValidator.email,
              label: AuthConstant.email,
              hintText: 'Enter your email address',
            ),

            AuthInputField(
              controller: phoneNumberController,
              validator: TValidator.phone,
              label: AuthConstant.phoneNumber,
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
            ),

            ValueListenableBuilder<bool>(
              valueListenable: hidePassword,
              builder: (context, isHidden, child) {
                return AuthInputField(
                  controller: passwordController,
                  validator: (value) => TValidator.validate('Password', value),
                  label: AuthConstant.password,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: 'Enter your password',
                  obscureText: isHidden,
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
              alignment: Alignment.center,
              child: AuthButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  context.read<AuthBloc>().add(
                    EmailSignUp(
                      emailController.text,
                      passwordController.text,
                      name: name.text,
                      phoneNumber: phoneNumberController.text,
                    ),
                  );
                },
                text: AuthConstant.signUp,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
