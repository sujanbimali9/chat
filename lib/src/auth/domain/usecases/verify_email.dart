import 'package:chat/core/usecase/usecase_getter.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';

class EmailVerifiedUseCase implements UseCaseGetter<bool> {
  final AuthRepository _authRepository;

  EmailVerifiedUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;
  @override
  bool call() {
    return _authRepository.emailVerified();
  }
}
