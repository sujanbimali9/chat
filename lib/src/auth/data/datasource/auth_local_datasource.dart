import 'dart:developer';

import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:drift/native.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser(String id);
  Future<UserModel?> getCachedUser(String id);
}

class AuthLocalDataSourceImp implements AuthLocalDataSource {
  final UserTableQuery _userQuery;

  AuthLocalDataSourceImp(final LocalDatabase localDatabase)
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
        name: 'AuthLocalDataSource.$context',
      );
      throw CacheException(e.message);
    } catch (e) {
      log('Unexpected Exception: $e', name: 'AuthLocalDataSource.$context');
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    return await _handleLocalException(() async {
      await _userQuery.insertUser(user);
    }, context: 'cacheUser');
  }

  @override
  Future<UserModel?> getCachedUser(String id) async {
    return await _handleLocalException(() async {
      return await _userQuery.getUserById(id);
    }, context: 'getCachedUser');
  }

  @override
  Future<void> clearUser(String id) async {
    return await _handleLocalException(() async {
      await _userQuery.deleteUser(id);
    }, context: 'clearUser');
  }
}
