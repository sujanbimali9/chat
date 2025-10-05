import 'package:chat/core/event/global_event_bus.dart';
import 'package:chat/core/routes/app_routes.dart';
import 'package:chat/utils/notification/notification_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/dependency.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/src/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/utils/constant/app_constants.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:chat/utils/notification/fcm_notification.dart';
import 'package:chat/utils/theme/theme.dart';

Future<void> main() async {
  final bindings = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: bindings);
  NetworkInfo.init(Connectivity());
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmNotification.init();
  await NotificationService.init();
  initDependency();

  GlobalEventBus.stream.listen((event) {
    if (event is TokenExpiredEvent) {
      serviceLocater<AuthBloc>().add(Logout());
    }
  });

  final details = await FlutterLocalNotificationsPlatform.instance
      .getNotificationAppLaunchDetails();
  final isNotificationLaunch = details?.didNotificationLaunchApp ?? false;

  runApp(MyApp(isNotificationLaunch: isNotificationLaunch));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isNotificationLaunch});

  final bool isNotificationLaunch;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    NetworkInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocater<AuthBloc>(),
      child: ValueListenableBuilder(
        valueListenable: TTheme.theme,
        builder: (context, value, child) {
          return AnimatedTheme(
            data: value == ThemeMode.light
                ? TTheme.lightTheme
                : TTheme.darkTheme,
            duration: AppConstants.themeTransitionDuration,
            curve: Curves.easeIn,
            child: MaterialApp.router(
              darkTheme: TTheme.darkTheme,
              theme: TTheme.lightTheme,
              themeMode: value,
              routerConfig: AppRouter.getRouter(
                isNotificationLaunch: widget.isNotificationLaunch,
              ),
              builder: (context, child) {
                ScreenUtil.init(context);
                return child!;
              },
            ),
          );
        },
      ),
    );
  }
}
