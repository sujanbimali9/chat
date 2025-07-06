import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignUpUseCase implements UseCase<User, SingUpParms> {
  final AuthRepository _authRepository;

  SignUpUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, User>> call(SingUpParms parms) async {
    return await _authRepository.register(
      parms.email,
      parms.password,
      name: parms.name,
      phoneNumber: parms.phoneNumber,
    );
  }
}

class SingUpParms {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;

  SingUpParms({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });
}
