import 'package:chat/src/auth/presentation/cubit/hide_password_login/hide_password_cubit.dart';
import 'package:chat/src/auth/presentation/widgets/social_icon.dart';
import 'package:chat/src/utils/color/color.dart';
import 'package:chat/src/utils/constant/auth_constant.dart';
import 'package:chat/src/utils/icons/assetsicons.dart';
import 'package:chat/src/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginForm extends HookWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = GlobalKey<FormState>();

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
            validator: TValidator.test,
          ),
          const SizedBox(height: 20),
          Text(AuthConstant.password,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          BlocSelector<HidePasswordLoginCubit, HidePasswordLoginState, bool>(
            selector: (state) {
              return state.isHidden;
            },
            builder: (context, isHidden) {
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
                      context
                          .read<HidePasswordLoginCubit>()
                          .togglePasswordVisibility();
                    },
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              Checkbox(value: true, onChanged: (value) {}),
              const Text('Remember me'),
              const Spacer(),
              TextButton(
                  style: TextButton.styleFrom(
                      overlayColor: const Color.fromARGB(0, 209, 154, 154)),
                  onPressed: () {},
                  child: const Text('forget password?')),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
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
                onPressed: () async {},
                icon: TIcons.google,
              ),
              const SizedBox(width: 20),
              TSocialMediaButton(
                onPressed: () async {},
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
