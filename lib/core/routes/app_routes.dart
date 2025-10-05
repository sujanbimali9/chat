import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import 'package:chat/core/common/model/user.dart';
import 'package:chat/dependency.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/src/auth/presentation/screen/login_screen.dart';
import 'package:chat/src/auth/presentation/screen/reset_password_screen.dart';
import 'package:chat/src/auth/presentation/screen/signup_screen.dart';
import 'package:chat/src/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat/src/chat/presentation/bloc/pending_chat_bloc/pending_chat_bloc.dart';
import 'package:chat/src/chat/presentation/bloc/reply_cubit/reply_cubit.dart';
import 'package:chat/src/chat/presentation/screen/chatscreen.dart';
import 'package:chat/src/home/presentation/bloc/all_user_bloc/all_user_bloc.dart';
import 'package:chat/src/home/presentation/bloc/conversation_history_bloc/conversation_history_bloc.dart';
import 'package:chat/src/home/presentation/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:chat/src/home/presentation/bloc/sync_chat/sync_chat_bloc.dart';
import 'package:chat/src/home/presentation/screen/homescreen.dart';

class RoutePaths {
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgetPassword = '/forget-password';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String initial = '/';
}

class RouteNames {
  static const String login = 'login';
  static const String signUp = 'signUp';
  static const String forgetPassword = 'forgetPassword';
  static const String home = 'home';
  static const String chat = 'chat';
  static const String initial = 'initial';
}

class AppRouter {
  static GoRouter? _router;

  static GoRouter getRouter({bool isNotificationLaunch = false}) {
    _router ??= GoRouter(
      initialLocation: RoutePaths.initial,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: RoutePaths.initial,
          name: RouteNames.initial,
          builder: (context, state) =>
              AppInitialScreen(isNotificationLaunch: isNotificationLaunch),
        ),

        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RoutePaths.signUp,
          name: RouteNames.signUp,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: RoutePaths.forgetPassword,
          name: RouteNames.forgetPassword,
          builder: (context, state) => const ResetPasswordScreen(),
        ),

        GoRoute(
          path: RoutePaths.home,
          name: RouteNames.home,
          builder: (context, state) {
            final user = state.extra as User?;
            if (user == null) {
              return const LoginScreen();
            }

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => serviceLocater<CurrentUserBloc>(),
                ),
                BlocProvider(create: (context) => serviceLocater<UserBloc>()),
                BlocProvider(
                  create: (context) => ConversationHistoryBloc(
                    serviceLocater(),
                    serviceLocater(),
                  ),
                ),
                BlocProvider(
                  create: (context) => serviceLocater<PendingChatBloc>(),
                  lazy: false,
                ),
                BlocProvider(
                  create: (context) => SyncChatBloc(serviceLocater()),
                  lazy: false,
                ),
              ],
              child: HomeScreen(user: user),
            );
          },
          routes: [
            GoRoute(
              path: RoutePaths.chat,
              name: RouteNames.chat,
              builder: (context, state) {
                final params = state.extra as Map<String, dynamic>;

                final user = params['user'] as User;
                final currentUser = params['currentUser'] as User;

                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => ReplyCubit()),
                    BlocProvider(
                      create: (context) => ChatBloc(
                        replyCubit: context.read<ReplyCubit>(),
                        userId: user.id,
                        currentUserId: currentUser.id,
                        serviceLocater(),
                        serviceLocater(),
                        serviceLocater(),
                      ),
                    ),
                  ],
                  child: ChatScreen(user: user, currentUser: currentUser),
                );
              },
            ),
          ],
        ),
      ],

      errorBuilder: (context, state) => ErrorScreen(
        error: state.error.toString(),
        path: state.matchedLocation,
      ),
      refreshListenable: GoRouterRefreshStream(
        serviceLocater<AuthBloc>().stream,
      ),
      // redirect: (context, state) {
      //   final authBloc = context.read<AuthBloc>();
      //   final authState = authBloc.state;
      //   if (authState is AuthLoggedOut) {
      //     return RoutePaths.login;
      //   }
      //   return null;
      // },
    );
    return _router!;
  }

  static GoRouter get router => _router ?? getRouter();
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppInitialScreen extends StatefulWidget {
  const AppInitialScreen({super.key, this.isNotificationLaunch = false});

  final bool isNotificationLaunch;

  @override
  State<AppInitialScreen> createState() => _AppInitialScreenState();
}

class _AppInitialScreenState extends State<AppInitialScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isNotificationLaunch) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, next) => next is! AuthInitial,
      listener: (context, state) {
        if (state is AuthLoggedIn) {
          FlutterNativeSplash.remove();
          context.goToHome(state.user);
        } else {
          FlutterNativeSplash.remove();
          context.goToLogin();
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error, required this.path});

  final String error;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error 404',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Page not found: $path',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension for convenient navigation methods
extension GoRouterExtensions on BuildContext {
  /// Navigate to login screen
  void goToLogin() => go(RoutePaths.login);

  /// Navigate to home screen with user data
  void goToHome(User user) => go(RoutePaths.home, extra: user);

  /// Push login screen
  void pushLogin() => push(RoutePaths.login);

  /// Push sign up screen
  void pushSignUp() => push(RoutePaths.signUp);

  /// Push forget password screen
  void pushForgetPassword() => push(RoutePaths.forgetPassword);

  /// Push chat screen with user parameters
  void pushChat({required User user, required User currentUser}) {
    push('/home/chat', extra: {'user': user, 'currentUser': currentUser});
  }
}
