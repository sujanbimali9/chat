import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:fpdart/fpdart.dart';

class UserLoggedInUseCase implements UseCase<User?, NoParams> {
  final AuthRepository _authRepository;

  UserLoggedInUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, User?>> call(NoParams parm) {
    return _authRepository.userLoggedIn();
  }
}
