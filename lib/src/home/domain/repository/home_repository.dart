import 'dart:io';

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

  // Future<Either<Failure, void>> sendFriendRequest(int id);
  // Future<Either<Failure, void>> acceptFriendRequest(int id);
  // Future<Either<Failure, void>> cancelFriendRequest(int id);
  // Future<Either<Failure, void>> removeFriend(int id);
  // Future<Either<Failure, void>> blockUser(int id);
  // Future<Either<Failure, void>> unblockUser(int id);
  // Future<Either<Failure, List<User>>> getFriends();
  // Future<Either<Failure, List<User>>> getBlocedUsers();
  // Future<Either<Failure, List<User>>> getFriendRequests();
  // Future<Either<Failure, List<User>>> getPendingRequests();
  // Future<Either<Failure, List<User>>> getSentRequests();

  Future<Either<Failure, void>> updateProfileImage(File file);
  Future<Either<Failure, void>> updateShowOnlineStatus(bool show);
}
