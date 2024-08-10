import 'package:chat/core/enum/chat_type.dart';

import 'chat_metadata.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String id;
  final String msg;
  final String toId;
  final bool read;
  final ChatType type;
  final String fromId;
  final int? readTime;
  final int sentTime;
  final ChatMetaData? metadata;
  final MessageStatus? status;

  const Chat({
    required this.id,
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.fromId,
    required this.readTime,
    required this.sentTime,
    required this.metadata,
    required this.status,
  });
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
      ];
}

enum MessageStatus { sending, sent, failed }

extension MessageStatusX on MessageStatus {
  bool get isSending => this == MessageStatus.sending;
  bool get isSent => this == MessageStatus.sent;
  bool get isFailed => this == MessageStatus.failed;
}
