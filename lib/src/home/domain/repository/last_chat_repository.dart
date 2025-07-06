import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class LastChatRepository {
  Either<Failure, Stream<Chat>> getLastChatsStream();
  Future<Either<Failure, ApiResponse<Chat>>> getLastChats(
      {required int limit, required int offset});
}
