import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogOutUseCase implements UseCase<AuthResponse, NoParams> {
  final AuthRepository _authRepository;

  LogOutUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;
  @override
  Future<Either<Failure, AuthResponse>> call(NoParams parms) async {
    return await _authRepository.logout();
  }
}

class NoParams {}
