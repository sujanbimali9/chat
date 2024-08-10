import 'dart:io';

import 'package:chat/core/failure/failure.dart';
import 'package:chat/core/usecase/usecase.dart';
import 'package:chat/src/home/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfileImageUseCase implements UseCase<void, File> {
  final HomeRepository _homeRepository;

  UpdateProfileImageUseCase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  @override
  Future<Either<Failure, void>> call(File file) async {
    return await _homeRepository.updateProfileImage(file);
  }
}
