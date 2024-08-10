import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/data/model/auth_result.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResendResetEmailUseCase implements UseCase<AuthResponse, String> {
  final AuthRepository _repository;

  ResendResetEmailUseCase(AuthRepository repository) : _repository = repository;

  @override
  Future<Either<Failure, AuthResponse>> call(String parms) async {
    return await _repository.resendResetEmail(parms);
  }
}
