import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateUserUseCase implements UseCase<User, NoParams> {
  final HomeRepository _homeRepository;

  CreateUserUseCase(HomeRepository homeRepository)
      : _homeRepository = homeRepository;
  @override
  Future<Either<Failure, User>> call(NoParams user) async {
    return await _homeRepository.createUser();
  }
}
