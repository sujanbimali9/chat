import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:chat/utils/database/table/user_table.dart';
import 'package:drift/drift.dart';

part 'user_table_query.g.dart';

@DriftAccessor(tables: [UserTable])
class UserTableQuery extends DatabaseAccessor<LocalDatabase>
    with _$UserTableQueryMixin {
  UserTableQuery(super.db);
  Future<UserModel> getUserById(String id) async {
    final user = await (select(userTable)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
    return UserModel.fromUserEntity(user);
  }

  Future<ApiResponse<UserModel>> getUsers(String currentUserId,
      {required int limit, required int offset}) async {
    final users = await (select(userTable)
          ..where((tbl) => tbl.id.equals(currentUserId).not())
          ..limit(limit, offset: offset))
        .get();

    final total = await getTotalUsersCount();
    return ApiResponse(
      data: users.map((e) => UserModel.fromUserEntity(e)).toList(),
      dataSource: ApiDataSource.local,
      pagination:
          Pagination(offset: offset + users.length, limit: limit, total: total),
    );
  }

  Future<int> getTotalUsersCount() async {
    final result = await customSelect(
      'SELECT COUNT(*) as count FROM user_table',
      readsFrom: {userTable},
    ).getSingle();

    return result.data['count'] as int;
  }

  Stream<List<UserModel>> getUsersStream() {
    final userStream = (select(userTable)).watch();
    return userStream
        .map((event) => event.map(UserModel.fromUserEntity).toList());
  }

  Future<ApiResponse<UserModel>> searchUser(String query,
      {required int limit, required int offset}) async {
    final users = await (select(userTable)
          ..where((tbl) => tbl.name.like('%$query%'))
          ..limit(limit, offset: offset)
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)
          ]))
        .get();

    final total = await getTotalUsersCount();
    return ApiResponse(
      data: users.map((e) => UserModel.fromUserEntity(e)).toList(),
      dataSource: ApiDataSource.local,
      pagination:
          Pagination(offset: offset + users.length, limit: limit, total: total),
    );
  }

  Future<void> insertUser(UserModel user) async {
    await into(userTable).insert(
      UserEntity.fromJson(
        user.toJson(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> insertUsers(List<UserModel> users) async {
    final userEntities = users.map((e) => UserEntity.fromJson(e.toJson()));
    await batch((batch) {
      batch.insertAll(
        userTable,
        userEntities,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> updateUser(UserModel user) async {
    await (update(userTable)..where((tbl) => tbl.id.equals(user.id)))
        .write(UserEntity.fromJson(user.toJson()));
  }

  Future<void> deleteUser(String userId) async {
    await (delete(userTable)..where((tbl) => tbl.id.equals(userId))).go();
  }

  Future<void> deleteAllUsers() async {
    await delete(userTable).go();
  }
}
