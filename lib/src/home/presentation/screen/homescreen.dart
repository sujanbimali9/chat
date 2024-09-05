import 'package:chat/main.dart';
import 'package:chat/src/home/presentation/bloc/home_bloc.dart';
import 'package:chat/src/home/presentation/widgets/app_bar.dart';
import 'package:chat/src/home/presentation/widgets/bottom_navigation.dart';
import 'package:chat/src/home/presentation/widgets/current_user_profile_image.dart';
import 'package:chat/src/home/presentation/widgets/user_tile.dart';
import 'package:chat/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulHookWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetUsersEvent());
    context.read<HomeBloc>().add(GetCurrentUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    useEffect(() {
      void onScroll() {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels != 0) {}
        }
      }

      scrollController.addListener(onScroll);

      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);
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
            final users = state.users.values;
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
                  final user = users.elementAt(index);
                  if (index == users.length - 1 && state.isFetchingMore) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return UserTile(user: user);
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
