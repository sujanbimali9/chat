import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChatUseCase implements UseCase<ApiResponse<Chat>, GetChatParms> {
  final ChatRepository _chatRepository;

  GetChatUseCase(ChatRepository chatRepository)
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, ApiResponse<Chat>>> call(GetChatParms parm) async {
    return await _chatRepository.getChats(
      parm.chatId,
      limit: parm.limit,
      offset: parm.offset,
    );
  }
}

class GetChatParms {
  final String chatId;
  final int limit;
  final int offset;

  GetChatParms({
    required this.chatId,
    this.limit = 10,
    this.offset = 0,
  });
}
