import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/src/home/presentation/widgets/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/common/model/user.dart';
import 'package:chat/dependency.dart';
import 'package:chat/src/home/presentation/bloc/all_user_bloc/all_user_bloc.dart';
import 'package:chat/src/home/presentation/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:chat/src/home/presentation/bloc/conversation_history_bloc/conversation_history_bloc.dart';
import 'package:chat/src/home/presentation/widgets/app_bar.dart';
import 'package:chat/src/home/presentation/widgets/current_user_profile_image.dart';
import 'package:chat/src/home/presentation/widgets/user_tile.dart';
import 'package:chat/utils/constant/constant.dart';
import 'package:chat/utils/services/socket_io.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController scrollController = ScrollController();
  late final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    serviceLocater<SocketIOService>().init(widget.user.id);
  }

  void _scrollListener() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {}
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
        showLeading: false,
        title: Text("Chats", style: Theme.of(context).textTheme.headlineLarge),
        actions: const [ThemChanger(), CurrentUserProfileImage()],
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

            return ValueListenableBuilder<int>(
              valueListenable: selectedIndex,
              builder: (context, value, _) {
                return [
                  _buildInteractedUsers(context),
                  _buildAllUsers(context),
                ][value];
              },
            );
          },
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, value, _) => NavigationBar(
          height: 70,
          selectedIndex: value,
          onDestinationSelected: (index) => selectedIndex.value = index,
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

  Widget _buildInteractedUsers(BuildContext context) {
    return BlocBuilder<ConversationHistoryBloc, ConversationHistory>(
      builder: (context, state) {
        return state.maybeMap(
          loaded: (data) => _buildChatList(usersWithChats: data.data),
          fetchingMore: (data) => _buildChatList(usersWithChats: data.data),
          error: (_) => const Center(child: Text('Error')),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildAllUsers(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return state.maybeMap(
          searchedUser: (e) => _buildChatListWithSearch(e.allUser),
          loaded: (state) => _buildChatListWithSearch(state.users),
          fetchingMore: (state) => _buildChatListWithSearch(state.users),
          error: (_) => const Center(child: Text('Error')),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildChatListWithSearch(List<User> users) {
    return Column(
      spacing: 10,
      children: [
        _buildSearchField(),
        Expanded(child: _buildChatList(users: users)),
      ],
    );
  }

  Widget _buildSearchField() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.r),
      borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
    );
    return SizedBox(
      height: 40,
      child: TextField(
        cursorHeight: 15,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
          prefixIcon: const Icon(Icons.search),
          enabledBorder: border,
          focusedBorder: border,
          border: border,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildChatList({
    List<User>? users,
    List<Conversation>? usersWithChats,
  }) {
    final isInteractedList = usersWithChats != null;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(const UserEvent.refreshUser());
      },
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: isInteractedList ? usersWithChats.length : users!.length,
        itemBuilder: (context, index) {
          if (isInteractedList) {
            final entry = usersWithChats[index];
            return UserTile(user: entry.user, lastChat: entry.chat);
          } else {
            final user = users![index];
            return UserTile(user: user);
          }
        },
      ),
    );
  }
}
