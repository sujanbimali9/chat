import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class SearchUserUseCase
    implements UseCase<ApiResponse<User>, SearchUserParams> {
  final UserRepository _userRepository;

  SearchUserUseCase(this._userRepository);

  @override
  Future<Either<Failure, ApiResponse<User>>> call(
      SearchUserParams params) async {
    return await _userRepository.searchUser(params.query,
        limit: params.limit, offset: params.offset);
  }
}

class SearchUserParams {
  final String query;
  final int limit;
  final int offset;

  SearchUserParams(
      {required this.query, required this.limit, required this.offset});
}
