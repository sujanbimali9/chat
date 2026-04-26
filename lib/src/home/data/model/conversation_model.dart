import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.g.dart';
part 'conversation_model.freezed.dart';

@freezed
class ConversationModel extends Conversation with _$ConversationModel {
  const factory ConversationModel({
    required final ChatModel chat,
    required final UserModel user,
    required final DateTime lastInteractionAt,
    required final int unreadCount,
  }) = _ConversationHistoryModel;

  factory ConversationModel.fromJson(dynamic json) =>
      _$ConversationModelFromJson(json);

  factory ConversationModel.fromConversation(Conversation conversation) =>
      ConversationModel(
        chat: ChatModel.fromChat(conversation.chat),
        user: UserModel.fromUser(conversation.user),
        lastInteractionAt: conversation.lastInteractionAt,
        unreadCount: conversation.unreadCount,
      );
}
