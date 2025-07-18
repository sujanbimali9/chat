import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:chat/src/chat/presentation/widgets/multimedia.dart';
import 'package:chat/src/chat/presentation/widgets/reply_chat_render_object.dart';
import 'package:chat/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/presentation/bloc/reply_cubit/reply_cubit.dart';
import 'package:chat/src/chat/presentation/widgets/file_chat.dart';
import 'package:chat/src/chat/presentation/widgets/image_chat.dart';
import 'package:chat/src/chat/presentation/widgets/rounded_container.dart';
import 'package:chat/src/chat/presentation/widgets/video_chat.dart';
import 'package:chat/src/chat/presentation/widgets/text_chat.dart';

class ChatContainer extends StatefulWidget {
  ChatContainer({
    required this.chat,
    required this.currentUser,
    required this.user,
    this.nextChat,
    this.previousChat,
    required this.isAfterDateSeparator,
    required this.isBeforeDateSeparator,
  }) : super(key: ValueKey(chat.id));

  final Chat chat;
  final User currentUser;
  final User user;
  final Chat? nextChat;
  final Chat? previousChat;
  final bool isAfterDateSeparator;
  final bool isBeforeDateSeparator;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  final ValueNotifier<Offset> offset = ValueNotifier(const Offset(0, 0));
  @override
  void dispose() {
    offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.chat.fromId == widget.currentUser.id;
    final isPreviousSameAuthor =
        widget.previousChat?.fromId == widget.chat.fromId;
    final isNextSameAuthor = widget.nextChat?.fromId == widget.chat.fromId;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        _buildAvatar(isUser, isNextSameAuthor),
        if (!isUser) const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (widget.isAfterDateSeparator) const SizedBox(height: 10),
              _buildChatBubble(isUser, isPreviousSameAuthor, isNextSameAuthor),
              ?_buildChatStatusIndicator(),
              if (!isNextSameAuthor || widget.isBeforeDateSeparator)
                const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(bool isUser, bool isNextSameAuthor) {
    if (isUser || (isNextSameAuthor && !widget.isBeforeDateSeparator)) {
      return const SizedBox(width: 25);
    }
    return TRoundedImage(
      isNetwork: true,
      image: widget.user.profileImage,
      height: 25,
      width: 25,
    );
  }

  Widget _buildChatBubble(
    bool isUser,
    bool isPreviousSameAuthor,
    bool isNextSameAuthor,
  ) {
    return GestureDetector(
      onHorizontalDragCancel: _onDragCancel,
      onHorizontalDragEnd: (details) async =>
          await _handleHorizontalDragEnd(details, isUser),
      onHorizontalDragUpdate: (details) =>
          _handleHorizontalDragUpdate(details, isUser),
      child: ValueListenableBuilder<Offset>(
        valueListenable: offset,
        builder: (context, value, child) {
          return FractionalTranslation(translation: value, child: child);
        },
        child: widget.chat.replyTo != null
            ? _buildReplyContent(isUser, isPreviousSameAuthor, isNextSameAuthor)
            : _buildChatContent(isUser, isPreviousSameAuthor, isNextSameAuthor),
      ),
    );
  }

  Widget _buildReplyContent(
    bool isUser,
    bool isPreviousSameAuthor,
    bool isNextSameAuthor,
  ) {
    final replyChat = widget.chat.replyTo!;

    return Column(
      children: [
        if (isUser)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.reply, size: 15, color: TColors.replyColor),
              const SizedBox(width: 5),
              Text(
                'You replied to  ${replyChat.toId == widget.chat.toId ? 'yourself' : widget.user.name}',
                style: const TextStyle(color: TColors.replyColor, fontSize: 12),
              ),
            ],
          ),
        Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: ReplyChat(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            chat: _buildChatContent(
              isUser,
              isPreviousSameAuthor,
              isNextSameAuthor,
            ),
            reply: _buildReplyType(replyChat),
          ),
        ),
      ],
    );
  }

  Widget _buildReplyType(Chat chat) {
    return switch (chat.type) {
      ChatType.text => _buildReplyText(chat.msg),
      ChatType.media => _buildReplyMedia(chat),
    };
  }

  Widget _buildReplyText(String text) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 54, 54, 54),
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: BoxConstraints(maxWidth: size.width * 0.7),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Text('$text\n'),
    );
  }

  Widget _buildReplyMedia(Chat chat) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width * 0.3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MultiMediaGrid(
          children: chat.medias
              .map(
                (e) => switch (e.type) {
                  MediaType.image => ImageChat(image: e, status: chat.status),
                  MediaType.video => VideoChat(
                    video: e,
                    status: chat.status,
                    isUser: chat.fromId == widget.currentUser.id,
                  ),
                  _ => FileChat(file: e, vertical: true),
                },
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildChatContent(
    bool isUser,
    bool isPreviousSameAuthor,
    bool isNextSameAuthor,
  ) {
    final borderRadius = _getBorderRadius(
      isPreviousSameAuthor,
      isUser,
      widget.isAfterDateSeparator,
      widget.isBeforeDateSeparator,
      isNextSameAuthor,
    );
    if (widget.chat.type == ChatType.text) {
      return TextChat(
        chat: widget.chat,
        isUser: isUser,
        borderRadius: borderRadius,
      );
    } else {
      return _buildMediaChat(isUser, borderRadius);
    }
  }

  Widget _buildMediaChat(bool isUser, BorderRadius borderRadius) {
    final size = MediaQuery.of(context).size;
    final images = widget.chat.medias.where((e) => e.type.isImage);
    final videos = widget.chat.medias.where((e) => e.type.isVideo);
    final files = widget.chat.medias.where((e) => e.type.isFile);
    return Container(
      margin: const EdgeInsets.only(top: 5),
      constraints: BoxConstraints(maxWidth: size.width * 0.5),
      child: Column(
        children: [
          ...files.map((file) {
            return FileChat(file: file, borderRadius: borderRadius);
          }),
          if (images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: MultiMediaGrid(
                  children: images.map((image) {
                    return ImageChat(image: image, status: widget.chat.status);
                  }).toList(),
                ),
              ),
            ),
          if (videos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: MultiMediaGrid(
                  children: videos.map((video) {
                    return VideoChat(
                      video: video,
                      status: widget.chat.status,
                      isUser: isUser,
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildChatStatusIndicator() {
    return switch (widget.chat.status) {
      MessageStatus.sending => const SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(strokeWidth: 1),
      ),
      MessageStatus.failed => const Icon(
        Icons.error,
        color: Colors.red,
        size: 15,
      ),
      MessageStatus.sent => null,
    };
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details, bool isUser) {
    final width = MediaQuery.of(context).size.width;
    final double dx = (details.primaryDelta! / width + offset.value.dx).clamp(
      isUser ? -0.5 : 0,
      isUser ? 0 : 0.5,
    );
    offset.value = Offset(dx, 0);
  }

  Future<void> _handleHorizontalDragEnd(
    DragEndDetails details,
    bool isUser,
  ) async {
    if (details.primaryVelocity != null &&
            (details.primaryVelocity!.abs() >= 50 &&
                isUser &&
                details.localPosition.dx > 0) ||
        offset.value.dx.abs() > 0.3) {
      context.read<ReplyCubit>().replyTo(widget.chat);
    }
    await _offsetReset();
  }

  Future<void> _onDragCancel() async {
    if (offset.value.dx.abs() > 0.2) {
      context.read<ReplyCubit>().replyTo(widget.chat);
    }

    await _offsetReset();
  }

  Future<void> _offsetReset() async {
    final offsetValue = offset.value;
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 10));
      offset.value = Offset.lerp(offsetValue, const Offset(0, 0), i / 10)!;
    }
    offset.value = const Offset(0, 0);
  }

  BorderRadius _getBorderRadius(
    bool isPreviousSameAuthor,
    bool isUser,
    bool isAfterDateSeparator,
    bool isBeforeDateSeparator,
    bool isNextSameAuthor,
  ) {
    return BorderRadius.only(
      topLeft: isPreviousSameAuthor && !isUser && !isAfterDateSeparator
          ? const Radius.circular(3)
          : const Radius.circular(20),
      topRight: isPreviousSameAuthor && isUser && !isAfterDateSeparator
          ? const Radius.circular(3)
          : const Radius.circular(20),
      bottomLeft: !isUser && !isBeforeDateSeparator && isNextSameAuthor
          ? const Radius.circular(3)
          : const Radius.circular(20),
      bottomRight: isUser && !isBeforeDateSeparator && isNextSameAuthor
          ? const Radius.circular(3)
          : const Radius.circular(20),
    );
  }
}
