import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase_stream.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUsersStream implements UseCaseStream<List<User>, NoParams> {
  final UserRepository _userRepository;

  GetUsersStream(this._userRepository);

  @override
  Either<Failure, Stream<List<User>>> call(NoParams params) {
    return _userRepository.getUsersStream();
  }
}
