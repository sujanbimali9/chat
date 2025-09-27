// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      msg: json['msg'] as String,
      read: json['read'] as bool,
      type: $enumDecode(_$ChatTypeEnumMap, json['type']),
      toId: json['toId'] as String,
      fromId: json['fromId'] as String,
      readTime: json['readTime'] == null
          ? null
          : DateTime.parse(json['readTime'] as String),
      sentTime: DateTime.parse(json['sentTime'] as String),
      medias: (json['medias'] as List<dynamic>)
          .map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$MessageStatusEnumMap, json['status']),
      replyTo: json['replyTo'] == null
          ? null
          : ChatModel.fromJson(json['replyTo']),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'msg': instance.msg,
      'read': instance.read,
      'type': _$ChatTypeEnumMap[instance.type]!,
      'toId': instance.toId,
      'fromId': instance.fromId,
      'readTime': instance.readTime?.toIso8601String(),
      'sentTime': instance.sentTime.toIso8601String(),
      'medias': instance.medias,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'replyTo': instance.replyTo,
    };

const _$ChatTypeEnumMap = {ChatType.text: 'text', ChatType.media: 'media'};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.failed: 'failed',
};
