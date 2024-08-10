import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoveChatUseCase implements UseCase<void, Chat> {
  final ChatRepository _chatRepository;

  RemoveChatUseCase(ChatRepository chatRepository)
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, void>> call(Chat parm) async {
    return await _chatRepository.removeChat(ChatModel.fromChat(parm));
  }
}
