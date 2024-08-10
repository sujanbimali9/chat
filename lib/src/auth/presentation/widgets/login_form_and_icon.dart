import 'package:chat/src/auth/presentation/widgets/login_form.dart';
import 'package:chat/src/utils/color/color.dart';
import 'package:chat/src/utils/icons/assetsicons.dart';
import 'package:flutter/material.dart';

class LoginFormAndIcon extends StatelessWidget {
  const LoginFormAndIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
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
    );
  }
}
