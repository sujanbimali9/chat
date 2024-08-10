import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/src/either.dart';

class UpdateUserUseCase implements UseCase<User, User> {
  final HomeRepository _homeRepository;

  UpdateUserUseCase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  @override
  Future<Either<Failure, User>> call(User parm) async {
    return await _homeRepository.updateUser(parm);
  }
}
