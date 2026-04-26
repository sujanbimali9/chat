import 'dart:io';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/common/model/user.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UserRepository {
  Future<Either<Failure, ApiResponse<User, UserPagination>>> getAllUsers({
    required int limit,
    required int offset,
    bool local = false,
  });
  Future<Either<Failure, ApiResponse<Conversation, ConversationPagination>>>
  getConversationHistory({
    required int limit,
    required int? lastInteractedAt,
    bool local = false,
  });
  Future<Either<Failure, User>> getCurretUser({required bool local});
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, ApiResponse<User, UserPagination>>> searchUser(
    String query, {
    required int limit,
    required int offset,
  });
  Future<Either<Failure, User>> updateProfileImage(File file);

  Either<Failure, Stream<List<Conversation>>> getConversationHistoryStream();
}
