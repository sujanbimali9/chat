import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase_stream.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChatStreamUseCase
    implements UseCaseStream<Map<int, Chat>, GetChatParms> {
  final ChatRepository _chatRepository;

  GetChatStreamUseCase(ChatRepository chatRepository)
      : _chatRepository = chatRepository;

  @override
  Either<Failure, Stream<Map<int, Chat>>> call(GetChatParms parms) {
    return _chatRepository.getChatsStream(
      parms.chatId,
      limit: parms.limit,
      offset: parms.offset,
    );
  }
}

class GetChatParms {
  final String chatId;
  final int? limit;
  final int? offset;

  GetChatParms({
    required this.chatId,
    this.limit = 10,
    this.offset = 0,
  });
}
