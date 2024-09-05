import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase_stream.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLastChatsUseCase
    implements UseCaseStream<Map<String, Chat>, List<String>> {
  final HomeRepository repository;

  GetLastChatsUseCase(this.repository);

  @override
  Either<Failure, Stream<Map<String, Chat>>> call(List<String> params) {
    return repository.getLastChat(params);
  }
}
