import 'dart:async';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, Chat>> sendChat(Chat chat);
  Either<Failure, Stream<Chat>> getChatsStream(String chatId);
  Future<Either<Failure, void>> updateReadStatus(String chatId, String userId);
  Future<Either<Failure, ApiResponse<Chat, ChatPagination>>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessageSentTime,
    required bool localOnly,
  });

  Future<Either<Failure, List<Chat>>> getPendingChat();
  Future<Either<Failure, void>> removeChat(Chat chat);
}
