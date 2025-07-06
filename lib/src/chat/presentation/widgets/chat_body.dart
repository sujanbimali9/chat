import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/src/chat/presentation/chat_bloc/chat_bloc.dart';
import 'package:chat/src/chat/presentation/screen/chatscreen.dart';
import 'package:chat/src/chat/presentation/widgets/chat_container.dart';
import 'package:chat/utils/dateformat/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        chatBloc.add(const FetchMore());
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
    final previousMessageTime = previousMessage.sentTime;
    final messageTime = message.sentTime;
    switch (separatorFrequency) {
      case SeparatorFrequency.days:
        final DateTime previousDate = previousMessageTime;
        final DateTime messageDate = messageTime;
        return previousDate.difference(messageDate).inDays.abs() > 0;
      case SeparatorFrequency.hours:
        final DateTime previousDate = previousMessageTime;
        final DateTime messageDate = messageTime;
        return previousDate.difference(messageDate).inHours.abs() > 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is ChatLoaded || state is ChatFetchingMore) {
            final chats = state.chats;
            return _buildChats(
              chats,
              state,
              fetchingMore: state is ChatFetchingMore,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView _buildChats(List<Chat> chats, ChatState state,
      {bool fetchingMore = false}) {
    return ListView.builder(
      controller: scrollController,
      reverse: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final Chat? previousMessage =
            index < chats.length - 1 ? chats[index + 1] : null;
        final Chat? nextMessage = index > 0 ? chats[index - 1] : null;
        final Chat message = chats[index];
        final bool isAfterDateSeparator = _shouldShowDateSeparator(
            previousMessage, message,
            separatorFrequency:
                DateTime.now().difference(message.sentTime).inHours >= 24
                    ? SeparatorFrequency.days
                    : SeparatorFrequency.hours);
        bool isBeforeDateSeparator = false;
        if (nextMessage != null) {
          isBeforeDateSeparator = _shouldShowDateSeparator(message, nextMessage,
              separatorFrequency:
                  DateTime.now().difference(message.sentTime).inHours >= 24
                      ? SeparatorFrequency.days
                      : SeparatorFrequency.hours);
        }

        return Column(
          children: [
            if (fetchingMore && chats.length == index + 1)
              const Center(child: CircularProgressIndicator()),
            if (isAfterDateSeparator)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  DateFormatter.formatDateSeparator(message.sentTime),
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
              chat: chats[index],
            ),
          ],
        );
      },
    );
  }
}
