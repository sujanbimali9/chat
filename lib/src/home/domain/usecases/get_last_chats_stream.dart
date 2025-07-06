import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase_stream.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/repository/last_chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLastChatsStreamUseCase implements UseCaseStream<Chat, NoParams> {
  final LastChatRepository _lastChatRepository;

  GetLastChatsStreamUseCase(this._lastChatRepository);

  @override
  Either<Failure, Stream<Chat>> call(NoParams params) {
    return _lastChatRepository.getLastChatsStream();
  }
}
