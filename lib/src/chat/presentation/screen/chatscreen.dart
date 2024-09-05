import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/dependency.dart';
import 'package:chat/src/chat/presentation/bloc/chat_bloc.dart';
import 'package:chat/src/chat/presentation/widgets/app_bar.dart';
import 'package:chat/src/chat/presentation/widgets/chat_container.dart';
import 'package:chat/src/chat/presentation/widgets/message_field.dart';
import 'package:chat/src/chat/presentation/widgets/profile_image.dart';
import 'package:chat/utils/dateformat/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chatscreen extends StatelessWidget {
  const Chatscreen({
    super.key,
    required this.user,
    required this.currentUser,
  });
  final User user;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(
        userId: user.id,
        currentUserId: currentUser.id,
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
        serviceLocater(),
      ),
      child: Scaffold(
        body: PopScope(
          onPopInvokedWithResult: (didPop, _) {},
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: ChatBody(
                    user: user,
                    currentUser: currentUser,
                  )),
              const Positioned(
                bottom: 0,
                child: SizedBox(
                  height: 60,
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MessageField(user: user, currentUser: currentUser))
            ],
          ),
        ),
        appBar: TAppBar(
          showLeading: true,
          toolbarHeight: 80.h,
          leadingWidth: screenSize.width * 0.5,
          leading: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              ProfileImage(
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                showActive: user.isOnline && user.showOnlineStatus,
                image: user.profileImage,
                isNetwork: true,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        user.userName.split(' ').first,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    if (user.isOnline) const Text('online'),
                    if (!user.isOnline)
                      Text(
                        DateFormatter.format(user.lastActive),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
          ],
        ),
      ),
    );
  }
}

enum SeparatorFrequency { days, hours }

class ChatBody extends StatefulWidget {
  final User user;
  final User currentUser;
  const ChatBody({super.key, required this.user, required this.currentUser});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late final ScrollController scrollController;
  late final ChatBloc chatBloc;
  @override
  void initState() {
    scrollController = ScrollController();
    chatBloc = context.read<ChatBloc>();

    scrollController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        chatBloc.add(const FetchMessagesEvent(limit: 20));
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool _shouldShowDateSeparator(Chat? previousMessage, Chat message,
      {SeparatorFrequency separatorFrequency = SeparatorFrequency.days}) {
    if (previousMessage == null) {
      return true;
    }
    final previousMessageTime =
        DateTime.fromMillisecondsSinceEpoch(previousMessage.sentTime);
    final messageTime = DateTime.fromMillisecondsSinceEpoch(message.sentTime);
    switch (separatorFrequency) {
      case SeparatorFrequency.days:
        final DateTime previousDate = previousMessageTime;
        final DateTime messageDate = messageTime;
        return previousDate.difference(messageDate).inDays.abs() > 0;
      case SeparatorFrequency.hours:
        final DateTime previousDate = previousMessageTime;
        final DateTime messageDate = messageTime;
        return previousDate.difference(messageDate).inHours.abs() > 0;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final chats = state.chats.values;
          return ListView.builder(
            controller: scrollController,
            reverse: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final Chat? previousMessage =
                  index < chats.length - 1 ? chats.elementAt(index + 1) : null;
              final Chat? nextMessage =
                  index > 0 ? chats.elementAt(index - 1) : null;
              final Chat message = chats.elementAt(index);
              final bool isAfterDateSeparator = _shouldShowDateSeparator(
                  previousMessage, message,
                  separatorFrequency:
                      DateTime.now().millisecondsSinceEpoch - message.sentTime >
                              86400000
                          ? SeparatorFrequency.days
                          : SeparatorFrequency.hours);
              bool isBeforeDateSeparator = false;
              if (nextMessage != null) {
                isBeforeDateSeparator = _shouldShowDateSeparator(
                    message, nextMessage,
                    separatorFrequency: DateTime.now().millisecondsSinceEpoch -
                                message.sentTime >
                            86400000
                        ? SeparatorFrequency.days
                        : SeparatorFrequency.hours);
              }

              return Column(
                children: [
                  if (state.fetchingMore && state.chats.length == index + 1)
                    const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(child: CircularProgressIndicator())),
                  if (isAfterDateSeparator)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(
                        DateFormatter.formatDateSeparator(
                            DateTime.fromMillisecondsSinceEpoch(
                                message.sentTime)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ChatContainer(
                    nextChat: nextMessage,
                    previousChat: previousMessage,
                    isAfterDateSeparator: isAfterDateSeparator,
                    isBeforeDateSeparator: isBeforeDateSeparator,
                    currentUser: widget.currentUser,
                    user: widget.user,
                    chat: chats.elementAt(index),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
