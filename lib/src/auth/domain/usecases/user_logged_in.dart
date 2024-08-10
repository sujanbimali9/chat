import 'package:chat/core/usecase/usecase_getter.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';

class UserLoggedInUseCase implements UseCaseGetter<bool> {
  final AuthRepository _authRepository;

  UserLoggedInUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;
  @override
  bool call() {
    return _authRepository.isUserLoggedIn();
  }
}
