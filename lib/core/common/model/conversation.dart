import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';

class Conversation {
  final Chat chat;
  final User user;
  final DateTime lastInteractionAt;
  final int unreadCount;
  const Conversation({
    required this.chat,
    required this.user,
    required this.lastInteractionAt,
    required this.unreadCount,
  });
}

extension ConversationExtension on Conversation {
  Conversation copyWith({
    Chat? chat,
    User? user,
    DateTime? lastInteractionAt,
    int? unreadCount,
  }) {
    return Conversation(
      chat: chat ?? this.chat,
      user: user ?? this.user,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
