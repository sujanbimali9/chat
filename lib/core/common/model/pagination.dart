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

  UserPagination copyWith({int? offet, int? limit, int? total}) {
    return UserPagination(
      offset: offet ?? offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toJson() {
    return {'offet': offset, 'limit': limit, 'total': total};
  }

  factory UserPagination.fromJson(Map<String, dynamic> map) {
    return UserPagination(
      offset: map['offset'],
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
