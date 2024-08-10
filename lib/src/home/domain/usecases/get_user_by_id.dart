import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserByIdUseCase implements UseCase<User, String> {
  final HomeRepository _homeRepository;

  GetUserByIdUseCase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;
  @override
  Future<Either<Failure, User>> call(String id) async {
    return await _homeRepository.getUserById(id);
  }
}
