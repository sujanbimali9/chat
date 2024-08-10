import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class SearchUserUseCase implements UseCase<Map<String, User>, String> {
  final HomeRepository _homeRepository;

  SearchUserUseCase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;
  @override
  Future<Either<Failure, Map<String, User>>> call(String query) async {
    return await _homeRepository.searchUser(query);
  }
}
