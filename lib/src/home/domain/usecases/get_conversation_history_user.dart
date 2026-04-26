import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetConverstationHistoryUserUseCase
    implements
        UseCase<
          ApiResponse<Conversation, ConversationPagination>,
          GetConversationParams
        > {
  final UserRepository _userRepository;

  GetConverstationHistoryUserUseCase(this._userRepository);

  @override
  Future<Either<Failure, ApiResponse<Conversation, ConversationPagination>>>
  call(GetConversationParams parm) async {
    return await _userRepository.getConversationHistory(
      limit: parm.limit,
      lastInteractedAt: parm.lastInteractedAt,
    );
  }
}

class GetConversationParams {
  final int limit;
  final int? lastInteractedAt;
  final bool local;

  GetConversationParams({
    required this.limit,
    this.lastInteractedAt,
    this.local = false,
  });
}
