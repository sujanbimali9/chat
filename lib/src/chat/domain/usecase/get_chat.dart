import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:chat/src/chat/domain/usecase/get_chat_stream.dart';
import 'package:fpdart/fpdart.dart';

class GetChatUseCase implements UseCase<Map<int, Chat>, GetChatParms> {
  final ChatRepository _chatRepository;

  GetChatUseCase(ChatRepository chatRepository)
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, Map<int, Chat>>> call(GetChatParms parm) async {
    return await _chatRepository.getChats(
      parm.chatId,
      limit: parm.limit,
      offset: parm.offset,
    );
  }
}
