import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/widgets/social_icon.dart';
import 'package:chat/utils/color/color.dart';
import 'package:chat/utils/constant/auth_constant.dart';
import 'package:chat/utils/icons/assetsicons.dart';
import 'package:chat/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

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
    const textStyle = TextStyle(fontSize: 18, color: Colors.black);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            AuthConstant.email,
            style: textStyle,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: emailController,
            validator: TValidator.email,
          ),
          const SizedBox(height: 20),
          const Text(
            AuthConstant.password,
            style: textStyle,
          ),
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
          const SizedBox(height: 10),
          const Text(
            AuthConstant.fullName,
            style: textStyle,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: name,
            validator: (value) => TValidator.validate('Full Name', value),
          ),
          const SizedBox(height: 10),
          const Text(
            AuthConstant.phoneNumber,
            style: textStyle,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: phoneNumberController,
            validator: TValidator.phone,
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                context.read<AuthBloc>().add(EmailSignUp(
                      emailController.text,
                      passwordController.text,
                      name: name.text,
                      phoneNumber: phoneNumberController.text,
                    ));
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text(AuthConstant.signUp),
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
