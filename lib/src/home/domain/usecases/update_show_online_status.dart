import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateOnlineStatusUseCase implements UseCase<void, bool> {
  final HomeRepository _homeRepository;

  UpdateOnlineStatusUseCase(HomeRepository homeRepository)
      : _homeRepository = homeRepository;

  @override
  Future<Either<Failure, void>> call(bool showOnline) async {
    return await _homeRepository.updateOnlineStatus(showOnline);
  }
}
