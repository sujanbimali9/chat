import 'package:chat/dependency.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/cubit/hide_password_login/hide_password_cubit.dart';
import 'package:chat/src/auth/presentation/screen/loginscreen.dart';
import 'package:chat/src/utils/theme/theme.dart';
import 'package:chat/.supabase_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependency();
  await Supabase.initialize(anonKey: anonKey, url: url);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocater<AuthBloc>(),
        ),
        BlocProvider(
            create: (context) => serviceLocater<HidePasswordLoginCubit>())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: TTheme.theme,
        darkTheme: TTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}
