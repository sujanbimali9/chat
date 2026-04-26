import 'package:equatable/equatable.dart';

class UserPagination extends Equatable {
  final int offset;
  final int limit;
  final int total;
  const UserPagination({
    required this.offset,
    required this.limit,
    required this.total,
  });

  @override
  List<Object?> get props => [offset, limit, total];

  UserPagination copyWith({int? lastInteractedAt, int? limit, int? total}) {
    return UserPagination(
      offset: lastInteractedAt ?? this.offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toJson() {
    return {'lastInteractedAt': offset, 'limit': limit, 'total': total};
  }

  factory UserPagination.fromJson(Map<String, dynamic> map) {
    return UserPagination(
      offset: map['lastInteractedAt'],
      limit: map['limit'],
      total: map['total'],
    );
  }
}

class ConversationPagination extends Equatable {
  final int? lastInteractedAt;
  final int limit;
  final int total;

  const ConversationPagination({
    required this.lastInteractedAt,
    required this.limit,
    required this.total,
  });

  @override
  List<Object?> get props => [lastInteractedAt, limit, total];

  ConversationPagination copyWith({
    int? lastInteractedAt,
    int? limit,
    int? total,
  }) {
    return ConversationPagination(
      lastInteractedAt: lastInteractedAt ?? this.lastInteractedAt,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastMessageTime': lastInteractedAt,
      'limit': limit,
      'total': total,
    };
  }

  factory ConversationPagination.fromJson(Map<String, dynamic> map) {
    return ConversationPagination(
      lastInteractedAt: map['lastMessageTime'],
      limit: map['limit'],
      total: map['total'],
    );
  }
}

class ChatPagination extends Equatable {
  final int limit;
  final int? lastMessageSentTime;
  final int? total;

  const ChatPagination({
    required this.limit,
    this.lastMessageSentTime,
    this.total,
  });

  @override
  List<Object?> get props => [limit, lastMessageSentTime, total];

  ChatPagination copyWith({int? limit, int? lastMessageSentTime, int? total}) {
    return ChatPagination(
      limit: limit ?? this.limit,
      lastMessageSentTime: lastMessageSentTime ?? this.lastMessageSentTime,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'lastMessageSentTime': lastMessageSentTime,
      'total': total,
    };
  }

  factory ChatPagination.fromJson(Map<String, dynamic> map) {
    return ChatPagination(
      limit: map['limit'],
      lastMessageSentTime: DateTime.parse(
        map['lastMessageSentTime'],
      ).millisecondsSinceEpoch,
      total: map['total'],
    );
  }
}
