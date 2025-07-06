import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/data/model/media_model.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat_model.g.dart';
part 'chat_model.freezed.dart';

@freezed
class ChatModel with _$ChatModel {
  factory ChatModel({
    required final String id,
    required final String chatId,
    required final String msg,
    required final bool read,
    required final ChatType type,
    required final String toId,
    required final String fromId,
    final DateTime? readTime,
    required final DateTime sentTime,
    required final List<MediaModel> medias,
    required final MessageStatus status,
    final ChatModel? replyTo,
  }) = _ChatModel;

  factory ChatModel.fromJson(json) => _$ChatModelFromJson(json);

  factory ChatModel.fromChat(Chat chat) => ChatModel(
        id: chat.id,
        chatId: chat.chatId,
        msg: chat.msg,
        toId: chat.toId,
        read: chat.read,
        type: chat.type,
        fromId: chat.fromId,
        readTime: chat.readTime,
        sentTime: chat.sentTime,
        status: chat.status,
        replyTo:
            chat.replyTo != null ? ChatModel.fromChat(chat.replyTo!) : null,
        medias: chat.medias.map((e) => MediaModel.fromMedia(e)).toList(),
      );

  factory ChatModel.fromChatEntity(ChatEntity e) {
    return ChatModel(
      id: e.id,
      chatId: e.chatId,
      msg: e.msg,
      toId: e.toId,
      read: e.read,
      type: e.type,
      fromId: e.fromId,
      readTime: e.readTime,
      sentTime: e.sentTime,
      medias: e.medias,
      status: e.status,
    );
  }
  factory ChatModel.fromLastChatEntity(LastChatEntity e) {
    return ChatModel(
      id: e.id,
      chatId: e.chatId,
      msg: e.msg,
      toId: e.toId,
      read: e.read,
      type: e.type,
      fromId: e.fromId,
      readTime: e.readTime,
      sentTime: e.sentTime,
      medias: e.medias,
      status: e.status,
    );
  }
}
