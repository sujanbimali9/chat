import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserLocalDataSource {
  Future<ApiResponse<UserModel>> getAllUser(
      {required int limit, required int offset});
  Stream<List<UserModel>> getUsersStream();
  Future<UserModel> getUserById(String id);
  Future<UserModel> updateUser(UserModel user);
  Future<ApiResponse<UserModel>> searchUser(
    String query, {
    required int limit,
    required int offset,
  });
  Future<void> saveUser(UserModel res);
  Future<void> deleteUser(String id);
  Future<UserModel> getCurrentUser();
  Future<void> saveUsers(List<UserModel> list);
}

class UserLocalDataSourceImp extends UserLocalDataSource {
  final UserTableQuery _userQuery;
  final FirebaseAuth _firebaseAuth;

  UserLocalDataSourceImp(LocalDatabase localDatabase, this._firebaseAuth)
      : _userQuery = localDatabase.userTableQuery;
  @override
  Future<ApiResponse<UserModel>> getAllUser(
      {required int limit, required int offset}) async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      final users =
          await _userQuery.getUsers(userId, limit: limit, offset: offset);
      return users;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final user = await _userQuery.getUserById(id);
      return user;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ApiResponse<UserModel>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) async {
    try {
      final users =
          await _userQuery.searchUser(query, limit: limit, offset: offset);
      return users;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      await _userQuery.updateUser(user);
      return user;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _userQuery.deleteUser(id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      final user = await _userQuery.getUserById(userId);
      return user;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> saveUser(UserModel res) async {
    try {
      await _userQuery.insertUser(res);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> saveUsers(List<UserModel> list) async {
    try {
      await _userQuery.insertUsers(list);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<UserModel>> getUsersStream() {
    try {
      return _userQuery.getUsersStream();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
