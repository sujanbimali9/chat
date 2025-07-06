import 'package:chat/core/common/model/media.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/generator/id_generator.dart';
import 'package:equatable/equatable.dart';

import 'package:chat/core/enum/chat_type.dart';

class Chat extends Equatable {
  final String id;
  final String chatId;
  final String msg;
  final bool read;
  final ChatType type;
  final String toId;
  final String fromId;
  final DateTime? readTime;
  final DateTime sentTime;
  final List<Media> medias;
  final MessageStatus status;
  final Chat? replyTo;

  Chat({
    required this.id,
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.fromId,
    required this.readTime,
    required this.sentTime,
    required this.medias,
    required this.status,
    this.replyTo,
  }) : chatId = IdGenerator.getConversionId(fromId, toId);
  @override
  get props => [
        msg,
        toId,
        read,
        type,
        fromId,
        readTime,
        sentTime,
        medias,
        status,
        chatId,
        replyTo,
      ];

  Chat copyWith({
    String? id,
    String? msg,
    String? toId,
    bool? read,
    ChatType? type,
    String? fromId,
    DateTime? readTime,
    DateTime? sentTime,
    List<Media>? medias,
    MessageStatus? status,
    Chat? replyTo,
  }) {
    return Chat(
      id: id ?? this.id,
      msg: msg ?? this.msg,
      toId: toId ?? this.toId,
      read: read ?? this.read,
      type: type ?? this.type,
      fromId: fromId ?? this.fromId,
      readTime: readTime ?? this.readTime,
      sentTime: sentTime ?? this.sentTime,
      medias: medias ?? this.medias,
      status: status ?? this.status,
      replyTo: replyTo ?? this.replyTo,
    );
  }

  factory Chat.fromChatModel(ChatModel result) {
    return Chat(
      id: result.id,
      msg: result.msg,
      toId: result.toId,
      read: result.read,
      type: result.type,
      fromId: result.fromId,
      readTime: result.readTime,
      sentTime: result.sentTime,
      medias: result.medias.map((e) => Media.fromMediaModel(e)).toList(),
      status: result.status,
      replyTo:
          result.replyTo != null ? Chat.fromChatModel(result.replyTo!) : null,
    );
  }
}

enum MessageStatus {
  sending,
  sent,
  failed;

  bool get isSending => this == MessageStatus.sending;
  bool get isSent => this == MessageStatus.sent;
  bool get isFailed => this == MessageStatus.failed;
}
