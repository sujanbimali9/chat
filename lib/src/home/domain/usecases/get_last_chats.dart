import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLastChatsUseCase
    implements UseCase<Map<String, String>, List<String>> {
  final HomeRepository repository;

  GetLastChatsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, String>>> call(
      List<String> chatIds) async {
    return await repository.getLastChat(chatIds);
  }
}
