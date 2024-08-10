import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendAudioUseCase implements UseCase<Chat, Chat> {
  final ChatRepository _chatRepository;

  SendAudioUseCase(ChatRepository chatRepository)
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, Chat>> call(Chat parm) async {
    return await _chatRepository.sendAudio(ChatModel.fromChat(parm));
  }
}
