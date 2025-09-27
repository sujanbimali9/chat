import 'package:chat/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemChanger extends StatelessWidget {
  const ThemChanger({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TTheme.theme,
      builder: (context, mode, _) {
        return IconButton(
          onPressed: () {
            TTheme.changeThemeMode(
              mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
            );
          },
          icon: Icon(
            mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
          ),
        );
      },
    );
  }
}
