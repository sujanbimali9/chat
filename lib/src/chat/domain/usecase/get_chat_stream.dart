import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase_stream.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChatStreamUseCase implements UseCaseStream<List<Chat>, String> {
  final ChatRepository _chatRepository;

  GetChatStreamUseCase(ChatRepository chatRepository)
    : _chatRepository = chatRepository;

  @override
  Either<Failure, Stream<List<Chat>>> call(String parms) {
    return _chatRepository.getChatsStream(parms);
  }
}
