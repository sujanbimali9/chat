import 'dart:developer';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:drift/native.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserLocalDataSource {
  Future<ApiResponse<UserModel, UserPagination>> getAllUser({
    required int limit,
    required int offset,
  });
  Future<ApiResponse<({UserModel user, ChatModel chat}), UserPagination>>
  getConversationHistory({required int limit, required int offset});
  Future<UserModel> getUserById(String id);
  Future<UserModel> updateUser(UserModel user);
  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  });
  Future<void> saveUser(UserModel res);
  Future<void> saveConversationHistory(UserModel user, ChatModel chat);
  Future<void> saveConversationsHistory(
    List<({UserModel user, ChatModel chat})> users,
  );
  Future<void> deleteUser(String id);
  Future<UserModel> getCurrentUser();
  Future<void> saveUsers(List<UserModel> list);

  Stream<List<({ChatModel chat, UserModel user})>>
  getConversationHistoryStream();
}

class UserLocalDataSourceImp extends UserLocalDataSource {
  final UserTableQuery _userQuery;
  final FirebaseAuth _firebaseAuth;

  UserLocalDataSourceImp(LocalDatabase localDatabase, this._firebaseAuth)
    : _userQuery = localDatabase.userTableQuery;

  Future<T> _handleLocalException<T>(
    Future<T> Function() fn, {
    String context = '',
  }) async {
    try {
      return await fn();
    } on SqliteException catch (e) {
      log(
        'SQLite Exception: ${e.message}',
        name: 'UserLocalDataSourceImp.$context',
      );
      throw CacheException(e.message);
    } catch (e) {
      log('Unexpected Exception: $e', name: 'UserLocalDataSourceImp.$context');
      throw CacheException(e.toString());
    }
  }

  @override
  Future<ApiResponse<UserModel, UserPagination>> getAllUser({
    required int limit,
    required int offset,
  }) async {
    return await _handleLocalException(() async {
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
  Future<UserModel> getUserById(String id) async {
    return await _handleLocalException(() async {
      final user = await _userQuery.getUserById(id);
      return user;
    }, context: 'getUserById');
  }

  @override
  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) async {
    return await _handleLocalException(() async {
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
    return await _handleLocalException(() async {
      final currentUser = await getCurrentUser();
      if (currentUser.id != user.id) {
        throw const ServerException('Cannot update user with different ID');
      }
      await _userQuery.updateUser(user);
      return await _userQuery.getUserById(user.id);
    }, context: 'updateUser');
  }

  @override
  Future<void> deleteUser(String id) async {
    return await _handleLocalException(() async {
      await _userQuery.deleteUser(id);
    }, context: 'deleteUser');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    return await _handleLocalException(() async {
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
    return await _handleLocalException(() async {
      await _userQuery.insertUser(res);
    }, context: 'saveUser');
  }

  @override
  Future<void> saveUsers(List<UserModel> list) async {
    return await _handleLocalException(() async {
      await _userQuery.insertUsers(list);
    }, context: 'saveUsers');
  }

  @override
  Future<ApiResponse<({UserModel user, ChatModel chat}), UserPagination>>
  getConversationHistory({required int limit, required int offset}) async {
    return await _handleLocalException(() async {
      final users = await _userQuery.getConversationHistory(
        limit: limit,
        offset: offset,
      );
      return users;
    }, context: 'getInteractedUser');
  }

  @override
  Future<void> saveConversationHistory(UserModel user, ChatModel chat) async {
    return await _handleLocalException(() async {
      await _userQuery.insertConversationHistory(user, chat);
    }, context: 'saveInteractedUser');
  }

  @override
  Future<void> saveConversationsHistory(
    List<({UserModel user, ChatModel chat})> users,
  ) async {
    return await _handleLocalException(() async {
      await _userQuery.insertConversationsHistory(users);
    }, context: 'saveInteractedUsers');
  }

  @override
  Stream<List<({ChatModel chat, UserModel user})>>
  getConversationHistoryStream() {
    try {
      return _userQuery.getInteractedUserStream();
    } on SqliteException catch (e) {
      log('SQLite Exception: ${e.message}', name: 'UserLocalDataSource');
      throw ServerException(e.message);
    } catch (e) {
      log('Unexpected Exception: $e', name: 'UserLocalDataSource');
      throw ServerException(e.toString());
    }
  }
}
