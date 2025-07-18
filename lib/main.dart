import 'package:chat/src/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat/src/chat/presentation/bloc/pending_chat_bloc/pending_chat_bloc.dart';
import 'package:chat/src/chat/presentation/bloc/reply_cubit/reply_cubit.dart';
import 'package:chat/src/home/presentation/bloc/interacted_user_bloc/interacted_user_bloc_bloc.dart';
import 'package:chat/utils/notification/notification_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/common/model/user.dart';
import 'package:chat/dependency.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/screen/forget_password_screen.dart';
import 'package:chat/src/auth/presentation/screen/login_screen.dart';
import 'package:chat/src/auth/presentation/screen/signup_screen.dart';
import 'package:chat/src/chat/presentation/screen/chatscreen.dart';
import 'package:chat/src/home/presentation/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:chat/src/home/presentation/bloc/all_user_bloc/all_user_bloc.dart';
import 'package:chat/src/home/presentation/screen/homescreen.dart';
import 'package:chat/utils/constant/routes.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:chat/utils/notification/fcm_notification.dart';
import 'package:chat/utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: bindings);
  NetworkInfo.init(Connectivity());
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmNotification.init();
  await NotificationService.init();
  initDependency();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    NetworkInfo.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      NetworkInfo.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocater<AuthBloc>()),
        BlocProvider(create: (context) => serviceLocater<CurrentUserBloc>()),
        BlocProvider(create: (context) => serviceLocater<UserBloc>()),
        BlocProvider(
          create: (context) =>
              InteractedUserBloc(serviceLocater(), serviceLocater()),
        ),
        BlocProvider(
          create: (context) => serviceLocater<PendingChatBloc>(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        theme: TTheme.theme,
        darkTheme: TTheme.darkTheme,
        themeMode: ThemeMode.system,
        routes: AppRoutes.routes,
        builder: (context, child) {
          ScreenUtil.init(context);
          return child!;
        },
        home: const AppInitial(),
      ),
    );
  }
}

class AppInitial extends StatelessWidget {
  const AppInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocListener<AuthBloc, AuthState>(
          listenWhen: (_, next) => next is! AuthInitial,
          listener: (context, state) {
            if (state is AuthLoggedIn) {
              FlutterNativeSplash.remove();
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.home,
                arguments: state.user,
                (route) => false,
              );
            } else {
              FlutterNativeSplash.remove();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
            }
          },
          child: const Scaffold(),
        );
      },
    );
  }
}

class AppRoutes {
  static final routes = <String, Widget Function(BuildContext context)>{
    Routes.login: (context) => const LoginScreen(),
    Routes.signUp: (context) => const SignUpScreen(),
    Routes.forgetPassword: (context) => const ForgetPasswordScreen(),
    Routes.home: (context) {
      final user = ModalRoute.of(context)?.settings.arguments as User;
      return HomeScreen(user: user);
    },
    Routes.chat: (context) {
      final parms =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final user = parms['user'] as User;
      final currentUser = parms['currentUser'] as User;
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ReplyCubit()),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
              replyCubit: context.read<ReplyCubit>(),
              userId: user.id,
              currentUserId: currentUser.id,
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
              serviceLocater(),
            ),
          ),
        ],
        child: Chatscreen(user: user, currentUser: currentUser),
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
      body: Center(child: Text('jError 404\n/$name Page not found')),
    );
  }
}
