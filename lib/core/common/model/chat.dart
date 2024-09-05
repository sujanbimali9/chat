import 'package:chat/utils/generator/id_generator.dart';
import 'package:equatable/equatable.dart';

import 'package:chat/core/enum/chat_type.dart';

import 'chat_metadata.dart';

class Chat extends Equatable {
  final String id;
  final String chatId;
  final String msg;
  final String toId;
  final bool read;
  final ChatType type;
  final String fromId;
  final int? readTime;
  final int sentTime;
  final ChatMetaData? metadata;
  final MessageStatus status;

  Chat({
    required this.id,
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.fromId,
    required this.readTime,
    required this.sentTime,
    this.metadata,
    required this.status,
  }) : chatId = IdGenerator.getConversionId(fromId, toId);
  @override
  get props => [
        id,
        msg,
        toId,
        read,
        type,
        fromId,
        readTime,
        sentTime,
        metadata,
        status,
        chatId,
      ];

  Chat copyWith({
    String? id,
    String? msg,
    String? toId,
    bool? read,
    ChatType? type,
    String? fromId,
    int? readTime,
    int? sentTime,
    ChatMetaData? metadata,
    MessageStatus? status,
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
      metadata: metadata ?? this.metadata,
      status: status ?? this.status,
    );
  }
}

MessageStatus getMessageStatus(String status) {
  switch (status) {
    case 'sending':
      return MessageStatus.sending;
    case 'sent':
      return MessageStatus.sent;
    case 'failed':
      return MessageStatus.failed;
    default:
      throw Exception('Unknown MessageStatus: $status');
  }
}

enum MessageStatus { sending, sent, failed }

extension MessageStatusX on MessageStatus {
  bool get isSending => this == MessageStatus.sending;
  bool get isSent => this == MessageStatus.sent;
  bool get isFailed => this == MessageStatus.failed;
}
