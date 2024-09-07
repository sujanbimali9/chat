import 'dart:developer';

import 'package:chat/src/home/presentation/bloc/home_bloc.dart';
import 'package:chat/src/home/presentation/widgets/app_bar.dart';
import 'package:chat/src/home/presentation/widgets/bottom_navigation.dart';
import 'package:chat/src/home/presentation/widgets/current_user_profile_image.dart';
import 'package:chat/src/home/presentation/widgets/user_tile.dart';
import 'package:chat/utils/constant/constant.dart';
import 'package:chat/utils/generator/id_generator.dart';
import 'package:chat/utils/notification/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    context.read<HomeBloc>().add(GetUsersEvent());
    context.read<HomeBloc>().add(GetCurrentUserEvent());
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('onMessageOpenedApp: $message');
    });
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels != 0) {}
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);

    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        toolbarHeight: 75.h,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          const SizedBox(width: 8),
          const CurrentUserProfileImage(),
        ],
        showLeading: false,
        title: Text(
          FirebaseChatValue.chat,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final users = state.users.values.toList();
            final lastChats = state.lastChats;
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (users.isEmpty) {
              return const Center(child: Text('No user found'));
            }
            return RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (index == users.length - 1 && state.isFetchingMore) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return UserTile(
                    user: user,
                    lastChat: lastChats[IdGenerator.getConversionId(
                      user.id,
                      state.currentUser?.id ?? '',
                    )],
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const HomeScreenBottomNavigation(),
    );
  }
}
