import 'dart:io';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, Map<String, User>>> getAllUser(
      {int? limit, int? offset});

  Future<Either<Failure, User>> getUserById(String id);
  Future<Either<Failure, User>> getCurretUser();
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, void>> deleteUser(String id);
  Future<Either<Failure, User>> createUser();
  Future<Either<Failure, Map<String, User>>> searchUser(String query);
  Either<Failure, Stream<Map<String, Chat>>> getLastChat(List<String> chatIds);

  Future<Either<Failure, void>> updateProfileImage(File file);
  Future<Either<Failure, void>> updateOnlineStatus(bool show);
}
