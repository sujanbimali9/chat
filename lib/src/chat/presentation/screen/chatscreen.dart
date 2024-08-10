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
import 'package:flutter_hooks/flutter_hooks.dart';

class Chatscreen extends HookWidget {
  const Chatscreen({super.key, required this.user, required this.currentUser});
  final User user;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scrollController = useScrollController();
    useEffect(() {
      scrollController.addListener(() async {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {}
        }
      });
      return () {};
    }, [scrollController]);

    return BlocProvider(
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
          onPopInvoked: (didPop) {},
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 40,
                left: 0,
                right: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      final chats = state.chats.values;
                      return ListView.builder(
                        controller: scrollController,
                        reverse: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final Chat? previousMessage = index < chats.length - 1
                              ? chats.elementAt(index + 1)
                              : null;
                          final Chat? nextMessage =
                              index > 0 ? chats.elementAt(index - 1) : null;
                          final Chat message = chats.elementAt(index);
                          final bool isAfterDateSeparator =
                              _shouldShowDateSeparator(previousMessage, message,
                                  separatorFrequency:
                                      DateTime.now().millisecondsSinceEpoch -
                                                  message.sentTime >
                                              86400000
                                          ? SeparatorFrequency.days
                                          : SeparatorFrequency.hours);
                          bool isBeforeDateSeparator = false;
                          if (nextMessage != null) {
                            isBeforeDateSeparator = _shouldShowDateSeparator(
                                message, nextMessage,
                                separatorFrequency:
                                    DateTime.now().millisecondsSinceEpoch -
                                                message.sentTime >
                                            86400000
                                        ? SeparatorFrequency.days
                                        : SeparatorFrequency.hours);
                          }

                          return Column(
                            children: [
                              const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              if (isAfterDateSeparator)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text(
                                    DateFormatter.formatDateSeparator(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            message.sentTime)),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ChatContainer(
                                nextChat: nextMessage,
                                previousChat: previousMessage,
                                isAfterDateSeparator: isAfterDateSeparator,
                                isBeforeDateSeparator: isBeforeDateSeparator,
                                currentUser: currentUser,
                                user: user,
                                chat: chats.elementAt(index),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
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
          toolbarHeight: 70,
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
                        user.username.split(' ').first,
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
          ],
        ),
      ),
    );
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
        final DateTime previousDate = DateTime(
          previousMessageTime.year,
          previousMessageTime.month,
          previousMessageTime.day,
        );
        final DateTime messageDate = DateTime(
          messageTime.year,
          messageTime.month,
          messageTime.day,
        );
        return previousDate.difference(messageDate).inDays.abs() > 0;
      case SeparatorFrequency.hours:
        final DateTime previousDate = DateTime(
          previousMessageTime.year,
          previousMessageTime.month,
          previousMessageTime.day,
          previousMessageTime.hour,
        );
        final DateTime messageDate = DateTime(
          messageTime.year,
          messageTime.month,
          messageTime.day,
          messageTime.hour,
        );
        return previousDate.difference(messageDate).inHours.abs() > 0;
      default:
        return false;
    }
  }
}

enum SeparatorFrequency { days, hours }
