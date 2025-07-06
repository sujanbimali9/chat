import 'dart:io';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UserRepository {
  Future<Either<Failure, ApiResponse<User>>> getAllUsers(
      {required int limit, required int offset});
  Future<Either<Failure, ApiResponse<User>>> getInteractedUser(
      {required int limit, required int offset});
  Future<Either<Failure, ApiResponse<User>>> getAllUserLocal(
      {required int limit, required int offset});
  Either<Failure, Stream<List<User>>> getUsersStream();
  Future<Either<Failure, User>> getCurretUser();
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, ApiResponse<User>>> searchUser(String query,
      {required int limit, required int offset});
  Future<Either<Failure, User>> updateProfileImage(File file);
}
