import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/local_database.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser(String id);
  Future<UserModel?> getCachedUser(String id);
}

class AuthLocalDataSourceImp implements AuthLocalDataSource {
  final UserTableQuery _userQuery;

  AuthLocalDataSourceImp(
    final LocalDatabase localDatabase,
  ) : _userQuery = localDatabase.userTableQuery;
  @override
  Future<void> cacheUser(UserModel user) async {}

  @override
  Future<UserModel?> getCachedUser(String id) async {
    return _userQuery.getUserById(id);
  }

  @override
  Future<void> clearUser(String id) async {
    _userQuery.deleteUser(id);
  }
}
