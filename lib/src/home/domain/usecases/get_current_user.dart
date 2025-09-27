import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUserUseCase implements UseCase<User, GetCurrentUserParams> {
  final UserRepository _userRepository;

  GetCurrentUserUseCase(this._userRepository);

  @override
  Future<Either<Failure, User>> call(parm) async {
    return await _userRepository.getCurretUser(local: parm.local);
  }
}

class GetCurrentUserParams {
  final bool local;
  const GetCurrentUserParams({this.local = false});
}
