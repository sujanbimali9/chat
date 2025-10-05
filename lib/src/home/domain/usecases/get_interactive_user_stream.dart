import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase_stream.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetConversationHistoryUseCaseStream
    implements UseCaseStream<List<Conversation>, NoParams> {
  final UserRepository _userRepository;

  GetConversationHistoryUseCaseStream(this._userRepository);

  @override
  Either<Failure, Stream<List<Conversation>>> call(NoParams params) {
    return _userRepository.getConversationHistoryStream();
  }
}
