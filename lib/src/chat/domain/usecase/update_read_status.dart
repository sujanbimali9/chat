import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateReadStatusUserCase
    implements UseCase<void, UpdateReadStatusParams> {
  final ChatRepository chatRepository;

  UpdateReadStatusUserCase(this.chatRepository);

  @override
  Future<Either<Failure, void>> call(UpdateReadStatusParams params) async {
    return await chatRepository.updateReadStatus(params.chatId, params.userId);
  }
}

class UpdateReadStatusParams {
  final String chatId;
  final String userId;

  UpdateReadStatusParams({
    required this.chatId,
    required this.userId,
  });
}
