import 'package:chat/core/common/model/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.msg,
    required super.toId,
    required super.read,
    required super.type,
    required super.fromId,
    required super.readTime,
    required super.sentTime,
    required super.metadata,
    required super.status,
  });
  ChatModel.fromChat(Chat chat)
      : this(
          id: chat.id,
          msg: chat.msg,
          toId: chat.toId,
          read: chat.read,
          type: chat.type,
          fromId: chat.fromId,
          readTime: chat.readTime,
          sentTime: chat.sentTime,
          metadata: chat.metadata,
          status: chat.status,
        );
}
