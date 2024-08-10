import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignUpUseCase implements UseCase<AuthResponse, SingUpParms> {
  final AuthRepository _authRepository;

  SignUpUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, AuthResponse>> call(SingUpParms parms) async {
    return await _authRepository.register(
      parms.email,
      parms.password,
      fullName: parms.fullName,
      username: parms.username,
      phoneNumber: parms.phoneNumber,
    );
  }
}

class SingUpParms {
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final String username;

  SingUpParms({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.username,
  });
}
