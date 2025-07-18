import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:chat/src/home/domain/usecases/get_user.dart';
import 'package:fpdart/fpdart.dart';

class GetInteractedUserUseCase
    implements
        UseCase<
          ApiResponse<({User user, Chat chat}), UserPagination>,
          GetUserParms
        > {
  final UserRepository _userRepository;

  GetInteractedUserUseCase(this._userRepository);

  @override
  Future<Either<Failure, ApiResponse<({User user, Chat chat}), UserPagination>>>
  call(GetUserParms parm) async {
    return await _userRepository.getInteractedUser(
      limit: parm.limit,
      offset: parm.offset,
    );
  }
}
