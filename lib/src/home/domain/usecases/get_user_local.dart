import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:chat/src/home/domain/usecases/get_user.dart';
import 'package:fpdart/fpdart.dart';

class GetAllUserLocalUseCase
    implements UseCase<ApiResponse<User>, GetUserParms> {
  final UserRepository _userRepository;

  GetAllUserLocalUseCase(this._userRepository);

  @override
  Future<Either<Failure, ApiResponse<User>>> call(GetUserParms parm) async {
    return await _userRepository.getAllUserLocal(
      limit: parm.limit,
      offset: parm.offset,
    );
  }
}
