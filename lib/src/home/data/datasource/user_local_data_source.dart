import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/mixins/exception_handler_mixin.dart';
import 'package:chat/src/home/data/model/conversation_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserLocalDataSource {
  Future<ApiResponse<UserModel, UserPagination>> getAllUser({
    required int limit,
    required int offset,
  });
  Future<ApiResponse<ConversationModel, ConversationPagination>>
  getConversationHistory({required int limit, int? lastInteractedAt});

  Future<UserModel> updateUser(UserModel user);
  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  });
  Future<void> saveUser(UserModel res);
  Future<void> saveConversationHistory(ConversationModel conversation);
  Future<void> saveConversationsHistory(List<ConversationModel> users);
  Future<UserModel> getCurrentUser();
  Future<void> saveUsers(List<UserModel> list);

  Stream<List<ConversationModel>> getConversationHistoryStream();
}

class UserLocalDataSourceImp
    with LocalExceptionHandlerMixin
    implements UserLocalDataSource {
  final UserTableQuery _userQuery;
  final FirebaseAuth _firebaseAuth;

  UserLocalDataSourceImp(LocalDatabase localDatabase, this._firebaseAuth)
    : _userQuery = localDatabase.userTableQuery;

  @override
  Future<ApiResponse<UserModel, UserPagination>> getAllUser({
    required int limit,
    required int offset,
  }) async {
    return await handleLocalException(() async {
      final userId = _firebaseAuth.currentUser!.uid;
      final users = await _userQuery.getUsers(
        userId,
        limit: limit,
        offset: offset,
      );
      return users;
    }, context: 'getAllUser');
  }

  @override
  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) async {
    return await handleLocalException(() async {
      final users = await _userQuery.searchUser(
        query,
        limit: limit,
        offset: offset,
      );
      return users;
    }, context: 'searchUser');
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    return await handleLocalException(() async {
      final currentUser = await getCurrentUser();
      if (currentUser.id != user.id) {
        throw const ServerException('Cannot update user with different ID');
      }
      await _userQuery.updateUser(user);
      return await _userQuery.getUserById(user.id);
    }, context: 'updateUser');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    return await handleLocalException(() async {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw const ServerException('No user is currently logged in');
      }
      final user = await _userQuery.getUserById(userId);
      return user;
    }, context: 'getCurrentUser');
  }

  @override
  Future<void> saveUser(UserModel res) async {
    return await handleLocalException(() async {
      await _userQuery.insertUser(res);
    }, context: 'saveUser');
  }

  @override
  Future<void> saveUsers(List<UserModel> list) async {
    return await handleLocalException(() async {
      await _userQuery.insertUsers(list);
    }, context: 'saveUsers');
  }

  @override
  Future<ApiResponse<ConversationModel, ConversationPagination>>
  getConversationHistory({required int limit, int? lastInteractedAt}) async {
    return await handleLocalException(() async {
      final users = await _userQuery.getConversationHistory(
        limit: limit,
        lastInteractedAt: lastInteractedAt,
      );
      return users;
    }, context: 'getConversationHistory');
  }

  @override
  Future<void> saveConversationHistory(ConversationModel conversation) async {
    return await handleLocalException(() async {
      await _userQuery.insertConversationHistory(conversation);
    }, context: 'saveConversationHistory');
  }

  @override
  Future<void> saveConversationsHistory(List<ConversationModel> users) async {
    return await handleLocalException(() async {
      await _userQuery.insertConversationsHistory(users);
    }, context: 'saveConversationsHistory');
  }

  @override
  Stream<List<ConversationModel>> getConversationHistoryStream() {
    try {
      return _userQuery.getConversationHistoryStream();
    } catch (e) {
      throw ServerException('Failed to get conversation history stream: $e');
    }
  }
}
