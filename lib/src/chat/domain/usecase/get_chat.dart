import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChatUseCase
    implements UseCase<ApiResponse<Chat, ChatPagination>, GetChatParms> {
  final ChatRepository _chatRepository;

  GetChatUseCase(ChatRepository chatRepository)
    : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, ApiResponse<Chat, ChatPagination>>> call(
    GetChatParms parm,
  ) async {
    return await _chatRepository.getChats(
      parm.chatId,
      limit: parm.limit,
      lastMessageSentTime: parm.lastChatSentTime,
      localOnly: parm.localOnly,
    );
  }
}

class GetChatParms {
  final String chatId;
  final bool localOnly;
  final int limit;
  final int? lastChatSentTime;

  GetChatParms({
    required this.chatId,
    this.limit = 10,
    this.lastChatSentTime,
    this.localOnly = false,
  });
}
