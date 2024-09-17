import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLastChatsUseCase implements UseCase<Map<String, Chat>, NoParams> {
  final HomeRepository repository;

  GetLastChatsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, Chat>>> call(NoParams params) {
    return repository.getLastChat();
  }
}
