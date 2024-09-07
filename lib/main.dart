import 'package:chat/dependency.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/cubit/hide_password_login/hide_password_cubit.dart';
import 'package:chat/src/auth/presentation/screen/loginscreen.dart';
import 'package:chat/src/chat/presentation/screen/chatscreen.dart';
import 'package:chat/src/home/presentation/bloc/home_bloc.dart';
import 'package:chat/src/home/presentation/screen/homescreen.dart';
import 'package:chat/utils/constant/routes.dart';
import 'package:chat/utils/notification/fcm_notification.dart';
import 'package:chat/utils/notification/notification_service.dart';
import 'package:chat/utils/theme/theme.dart';
import 'package:chat/.supabase_key.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependency();
  ScreenUtil.ensureScreenSize();
  await supabase.Supabase.initialize(anonKey: anonKey, url: url);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmNotification.init();
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocater<AuthBloc>()),
        BlocProvider(
            create: (context) => serviceLocater<HidePasswordLoginCubit>()),
        BlocProvider(create: (context) => serviceLocater<HomeBloc>())
      ],
      child: MaterialApp(
        theme: TTheme.theme,
        darkTheme: TTheme.darkTheme,
        themeMode: ThemeMode.system,
        routes: AppRoutes.routes,
        home: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) {
            return false;
          },
          builder: (context, state) {
            ScreenUtil.init(context);
            return state is AuthLoggedIn
                ? const HomeScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}

class AppRoutes {
  static final routes = <String, Widget Function(BuildContext context)>{
    Routes.login: (context) => const LoginScreen(),
    Routes.home: (context) => const HomeScreen(),
    Routes.chat: (context) {
      final parms =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      return Chatscreen(
        user: parms['user'],
        currentUser: parms['currentUser'],
      );
    },
  };
}

class UnkownRoute extends StatelessWidget {
  const UnkownRoute(this.settings, {super.key});
  final RouteSettings settings;

  @override
  Widget build(BuildContext context) {
    final name = settings.name ?? '';

    return Scaffold(
      body: Center(
        child: Text('          Error 404\n/$name Page not found'),
      ),
    );
  }
}
