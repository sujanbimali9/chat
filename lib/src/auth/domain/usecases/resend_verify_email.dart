import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResendVerifyEmailUseCase implements UseCase<AuthResponse, String> {
  final AuthRepository _repository;

  ResendVerifyEmailUseCase(AuthRepository repository)
      : _repository = repository;

  @override
  Future<Either<Failure, AuthResponse>> call(String email) async {
    return await _repository.resendEmailVerification(email);
  }
}
