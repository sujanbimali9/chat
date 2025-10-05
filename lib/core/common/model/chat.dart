import 'package:chat/core/common/model/media.dart';
import 'package:chat/utils/generator/id_generator.dart';

import 'package:chat/core/enum/chat_type.dart';

class Chat {
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
}

extension ChatExtension on Chat {
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
}

enum MessageStatus {
  sending,
  sent,
  failed;

  bool get isSending => this == MessageStatus.sending;
  bool get isSent => this == MessageStatus.sent;
  bool get isFailed => this == MessageStatus.failed;
}
