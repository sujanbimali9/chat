// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationHistoryModelImpl _$$ConversationHistoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationHistoryModelImpl(
  chat: ChatModel.fromJson(json['chat']),
  user: UserModel.fromJson(json['user']),
  lastInteractionAt: DateTime.parse(json['lastInteractionAt'] as String),
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$$ConversationHistoryModelImplToJson(
  _$ConversationHistoryModelImpl instance,
) => <String, dynamic>{
  'chat': instance.chat,
  'user': instance.user,
  'lastInteractionAt': instance.lastInteractionAt.toIso8601String(),
  'unreadCount': instance.unreadCount,
};
