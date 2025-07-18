import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase_stream.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetInteractedUserUseCaseStream
    implements UseCaseStream<List<({User user, Chat chat})>, NoParams> {
  final UserRepository _userRepository;

  GetInteractedUserUseCaseStream(this._userRepository);

  @override
  Either<Failure, Stream<List<({Chat chat, User user})>>> call(
      NoParams params) {
    return _userRepository.getInteractedUserStream();
  }
}
