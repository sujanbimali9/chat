import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/last_chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLastChatsUseCase
    implements UseCase<ApiResponse<Chat>, GetLastChatsParams> {
  final LastChatRepository _lastChatRepository;

  GetLastChatsUseCase(this._lastChatRepository);

  @override
  Future<Either<Failure, ApiResponse<Chat>>> call(
      GetLastChatsParams parm) async {
    return await _lastChatRepository.getLastChats(
      limit: parm.limit,
      offset: parm.offset,
    );
  }
}

class GetLastChatsParams {
  final int limit;
  final int offset;

  GetLastChatsParams({required this.limit, required this.offset});
}
