import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateReadUseCase implements UseCase<void, String> {
  final ChatRepository _chatRepository;

  UpdateReadUseCase(this._chatRepository);

  @override
  Future<Either<Failure, void>> call(String parm) async {
    return _chatRepository.updateReadStatus(parm);
  }
}
