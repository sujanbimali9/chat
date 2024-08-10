import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForgetPasswordUseCase
    implements UseCase<AuthResponse, ForgetPasswordParms> {
  final AuthRepository _authRepository;

  ForgetPasswordUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, AuthResponse>> call(ForgetPasswordParms parms) async {
    return await _authRepository.forgotPassword(parms.email);
  }
}

class ForgetPasswordParms {
  final String email;
  ForgetPasswordParms({required this.email});
}
