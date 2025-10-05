import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.g.dart';
part 'conversation_model.freezed.dart';

@freezed
class ConversationModel with _$ConversationModel implements Conversation {
  const factory ConversationModel({
    required final ChatModel chat,
    required final UserModel user,
    required final DateTime lastInteractionAt,
    required final int unreadCount,
  }) = _ConversationHistoryModel;

  factory ConversationModel.fromJson(json) => _$ConversationModelFromJson(json);
}
