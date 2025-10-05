import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:chat/src/home/domain/usecases/get_user.dart';
import 'package:fpdart/fpdart.dart';

class GetConverstationHistoryUserUseCase
    implements
        UseCase<ApiResponse<Conversation, UserPagination>, GetUserParms> {
  final UserRepository _userRepository;

  GetConverstationHistoryUserUseCase(this._userRepository);

  @override
  Future<Either<Failure, ApiResponse<Conversation, UserPagination>>> call(
    GetUserParms parm,
  ) async {
    return await _userRepository.getConversationHistory(
      limit: parm.limit,
      offset: parm.offset,
    );
  }
}
