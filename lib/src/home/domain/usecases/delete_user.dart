import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteUserUseCase implements UseCase<void, String> {
  final HomeRepository _homeRepository;

  DeleteUserUseCase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await _homeRepository.deleteUser(id);
  }
}
