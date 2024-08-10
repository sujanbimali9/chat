import 'package:chat/core/usecase/usecase_getter.dart';
import 'package:chat/src/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class CurrentUserUseCase implements UseCaseGetter<supabase.User?> {
  final AuthRepository _authRepository;

  CurrentUserUseCase(AuthRepository authRepository)
      : _authRepository = authRepository;
  @override
  supabase.User? call() {
    return _authRepository.currentUser();
  }
}
