import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllUserUseCase implements UseCase<Map<String, User>, GetUserParms> {
  final HomeRepository _homeRepository;

  GetAllUserUseCase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;
  @override
  Future<Either<Failure, Map<String, User>>> call(GetUserParms parm) async {
    return await _homeRepository.getAllUser(
      limit: parm.limit,
      offset: parm.offset,
    );
  }
}

class GetUserParms {
  final int limit;
  final int offset;

  GetUserParms({required this.limit, required this.offset});
}
