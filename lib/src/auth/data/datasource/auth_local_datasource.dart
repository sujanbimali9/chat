import 'package:chat/core/mixins/exception_handler_mixin.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/local_database.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser(String id);
  Future<UserModel?> getCachedUser(String id);
}

class AuthLocalDataSourceImp
    with LocalExceptionHandlerMixin
    implements AuthLocalDataSource {
  final UserTableQuery _userQuery;

  AuthLocalDataSourceImp(final LocalDatabase localDatabase)
    : _userQuery = localDatabase.userTableQuery;

  @override
  Future<void> cacheUser(UserModel user) async {
    return await handleLocalException(() async {
      await _userQuery.insertUser(user);
    }, context: 'cacheUser');
  }

  @override
  Future<UserModel?> getCachedUser(String id) async {
    return await handleLocalException(() async {
      return await _userQuery.getUserById(id);
    }, context: 'getCachedUser');
  }

  @override
  Future<void> clearUser(String id) async {
    return await handleLocalException(() async {
      await _userQuery.deleteUser(id);
    }, context: 'clearUser');
  }
}
