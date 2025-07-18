import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllUsersUseCase
    implements UseCase<ApiResponse<User, UserPagination>, GetUserParms> {
  final UserRepository _userRepository;

  GetAllUsersUseCase(this._userRepository);

  @override
  Future<Either<Failure, ApiResponse<User, UserPagination>>> call(
    GetUserParms parm,
  ) async {
    return await _userRepository.getAllUsers(
      limit: parm.limit,
      offset: parm.offset,
    );
  }
}

class GetUserParms {
  final int limit;
  final int offset;

  GetUserParms({required this.limit, required this.offset});
}
