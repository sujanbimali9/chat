import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class EmailAndPasswordLoginUseCase
    implements UseCase<User, LoginWithEmailParms> {
  final AuthRepository _authRepository;

  EmailAndPasswordLoginUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, User>> call(LoginWithEmailParms parms) async {
    return await _authRepository.loginWithEmailAndPassword(
        parms.email, parms.password);
  }
}

class LoginWithEmailParms {
  final String email;
  final String password;

  LoginWithEmailParms({required this.email, required this.password});
}
