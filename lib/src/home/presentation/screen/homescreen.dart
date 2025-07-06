import 'package:chat/core/common/model/user.dart';
import 'package:chat/dependency.dart';
import 'package:chat/src/home/presentation/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:chat/src/home/presentation/bloc/interacted_user_bloc/interacted_user_bloc_bloc.dart';
import 'package:chat/src/home/presentation/bloc/last_chat_bloc/last_chat_bloc.dart';
import 'package:chat/src/home/presentation/bloc/all_user_bloc/all_user_bloc.dart';
import 'package:chat/src/home/presentation/widgets/app_bar.dart';
import 'package:chat/src/home/presentation/widgets/current_user_profile_image.dart';
import 'package:chat/src/home/presentation/widgets/user_tile.dart';
import 'package:chat/utils/constant/constant.dart';
import 'package:chat/utils/generator/id_generator.dart';
import 'package:chat/utils/services/socket_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final User user;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController scrollController;
  late final ValueNotifier<int> selectedIndex;
  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    serviceLocater<SocketIOService>().init(widget.user.id);

    selectedIndex = ValueNotifier(0);
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
    selectedIndex.dispose();
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
          "Chats",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
          builder: (context, state) {
            final currentUser = state.mapOrNull(
              loaded: (e) => e.user,
              imageUploading: (e) => e.user,
            );
            if (currentUser == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ValueListenableBuilder(
                valueListenable: selectedIndex,
                builder: (context, value, child) => value == 0
                    ? BlocBuilder<InteractedUserBloc, InteractedUserState>(
                        builder: (context, state) {
                          final users = state.mapOrNull(
                            loaded: (e) => e.users,
                            fetchingMore: (value) => value.users,
                          );
                          return state.map<Widget>(
                            initial: (e) => const Center(
                                child: CircularProgressIndicator()),
                            loading: (e) => const Center(
                                child: CircularProgressIndicator()),
                            error: (w) => const Center(child: Text('Error')),
                            loaded: (e) =>
                                _buildInteractedUserList(users!, currentUser),
                            fetchingMore: (e) =>
                                _buildInteractedUserList(users!, currentUser),
                          );
                        },
                      )
                    : BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          final users = state.mapOrNull(
                            loaded: (e) => e.users,
                            fetchingMore: (value) => value.users,
                          );
                          return state.map<Widget>(
                            initial: (e) => const Center(
                                child: CircularProgressIndicator()),
                            loading: (e) => const Center(
                                child: CircularProgressIndicator()),
                            error: (w) => const Center(child: Text('Error')),
                            loaded: (e) =>
                                _buildInteractedUserList(users!, currentUser),
                            fetchingMore: (e) =>
                                _buildInteractedUserList(users!, currentUser),
                            searchedUser: (e) =>
                                _buildAllUserList(e.allUser, currentUser),
                          );
                        },
                      ));
          },
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, value, child) => NavigationBar(
          height: 70,
          selectedIndex: value,
          onDestinationSelected: (value) {
            selectedIndex.value = value;
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat),
              label: FirebaseChatValue.chat,
            ),
            NavigationDestination(
              icon: Icon(Icons.group),
              label: FirebaseChatValue.people,
            ),
          ],
        ),
      ),
    );
  }

  _buildAllUserList(List<User> users, User currentUser) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
          ),
        ),
        BlocBuilder<LastChatBloc, LastChatState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(const UserEvent.refreshUser());
              },
              child: ListView.builder(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final lastChats = state.mapOrNull(loaded: (e) => e.chat);
                  final user = users[index];
                  return UserTile(
                    user: user,
                    lastChat: lastChats?[IdGenerator.getConversionId(
                      user.id,
                      currentUser.id,
                    )],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  _buildInteractedUserList(List<User> users, User currentUser) {
    return BlocBuilder<LastChatBloc, LastChatState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<UserBloc>().add(const UserEvent.refreshUser());
            context
                .read<LastChatBloc>()
                .add(const LastChatEvent.refreshLastChat());
          },
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final lastChats = state.mapOrNull(loaded: (e) => e.chat);
              final user = users[index];
              return UserTile(
                user: user,
                lastChat: lastChats?[IdGenerator.getConversionId(
                  user.id,
                  currentUser.id,
                )],
              );
            },
          ),
        );
      },
    );
  }
}
