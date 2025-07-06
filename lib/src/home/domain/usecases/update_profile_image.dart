import 'dart:io';

import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfileImageUseCase implements UseCase<User, File> {
  final UserRepository _userRepository;

  UpdateProfileImageUseCase(this._userRepository);

  @override
  Future<Either<Failure, User>> call(File file) async {
    return await _userRepository.updateProfileImage(file);
  }
}
