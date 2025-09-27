import 'dart:convert';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:chat/utils/database/table/user_table.dart';
import 'package:drift/drift.dart';

part 'user_table_query.g.dart';

@DriftAccessor(tables: [UserTable, ConversationHistoryTable])
class UserTableQuery extends DatabaseAccessor<LocalDatabase>
    with _$UserTableQueryMixin {
  UserTableQuery(super.db);
  Future<UserModel> getUserById(String id) async {
    final user = await (select(
      userTable,
    )..where((tbl) => tbl.id.equals(id))).getSingle();
    return UserModel.fromUserEntity(user);
  }

  Future<ApiResponse<UserModel, UserPagination>> getUsers(
    String currentUserId, {
    required int limit,
    required int offset,
  }) async {
    final users =
        await (select(userTable)
              ..where((tbl) => tbl.id.equals(currentUserId).not())
              ..limit(limit, offset: offset))
            .get();

    final total = await getTotalUsersCount();
    return ApiResponse(
      data: users.map((e) => UserModel.fromUserEntity(e)).toList(),
      dataSource: ApiDataSource.local,
      pagination: UserPagination(
        offset: offset + users.length,
        limit: limit,
        total: total,
      ),
    );
  }

  Future<ApiResponse<({UserModel user, ChatModel chat}), UserPagination>>
  getConversationHistory({required int limit, required int offset}) async {
    final result =
        await (select(
          conversationHistoryTable,
        )..limit(limit, offset: offset)).join([
          innerJoin(
            userTable,
            userTable.id.equalsExp(conversationHistoryTable.userId),
          ),
        ]).get();

    final data = result.map((row) {
      final user = UserModel.fromUserEntity(row.readTable(userTable));
      final chat = ChatModel.fromJson(row.readTable(chatTable).toJson());
      return (user: user, chat: chat);
    }).toList();
    final total = await getTotalConversationHistoryCount();
    return ApiResponse(
      data: data,
      dataSource: ApiDataSource.local,
      pagination: UserPagination(
        offset: offset + result.length,
        limit: limit,
        total: total,
      ),
    );
  }

  Future<int> getTotalUsersCount() async {
    final result = await customSelect(
      'SELECT COUNT(*) as count FROM user_table',
      readsFrom: {userTable},
    ).getSingle();
    return result.data['count'] as int;
  }

  Future<int> getTotalConversationHistoryCount() async {
    final result = await customSelect(
      'SELECT COUNT(*) as count FROM conversation_history_table',
      readsFrom: {conversationHistoryTable},
    ).getSingle();

    return result.data['count'] as int;
  }

  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) async {
    final users =
        await (select(userTable)
              ..where((tbl) => tbl.name.like('%$query%'))
              ..limit(limit, offset: offset)
              ..orderBy([
                (tbl) =>
                    OrderingTerm(expression: tbl.name, mode: OrderingMode.asc),
              ]))
            .get();

    final total = await getTotalUsersCount();
    return ApiResponse(
      data: users.map((e) => UserModel.fromUserEntity(e)).toList(),
      dataSource: ApiDataSource.local,
      pagination: UserPagination(
        offset: offset + users.length,
        limit: limit,
        total: total,
      ),
    );
  }

  Future<void> insertUser(UserModel user) async {
    await into(userTable).insert(
      UserEntity.fromJson(user.toJson()),
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
    await (update(userTable)..where((tbl) => tbl.id.equals(user.id))).write(
      UserEntity.fromJson(user.toJson()),
    );
  }

  Future<void> deleteUser(String userId) async {
    await (delete(userTable)..where((tbl) => tbl.id.equals(userId))).go();
  }

  Future<void> deleteAllUsers() async {
    await delete(userTable).go();
  }

  Future<void> insertConversationHistory(UserModel user, ChatModel chat) async {
    transaction(() async {
      await into(conversationHistoryTable).insert(
        ConversationHistoryEntity(
          userId: user.id,
          lastInteractedAt: chat.sentTime,
          chatId: chat.chatId,
          lastMessage: chat.id,
        ),
        mode: InsertMode.insertOrReplace,
      );
      await into(userTable).insert(
        UserEntity.fromJson(user.toJson()),
        mode: InsertMode.insertOrReplace,
      );
      await into(chatTable).insert(
        ChatEntity.fromJson({
          ...chat.toJson(),
          'medias': jsonEncode(chat.medias),
          'replyToId': chat.replyTo?.id,
        }),
        mode: InsertMode.insert,
        onConflict: DoNothing(),
      );
    });
  }

  Future<void> insertConversationsHistory(
    List<({UserModel user, ChatModel chat})> data,
  ) async {
    transaction(() async {
      await batch((batch) {
        batch.insertAll(
          chatTable,
          data
              .map(
                (e) => ChatEntity.fromJson({
                  ...e.chat.toJson(),
                  'medias': jsonEncode(e.chat.medias),
                  'replyToId': e.chat.replyTo?.id,
                }),
              )
              .toList(),
          mode: InsertMode.insert,
          onConflict: DoNothing(),
        );

        batch.insertAll(
          userTable,
          data.map((e) => UserEntity.fromJson(e.user.toJson())).toList(),
          mode: InsertMode.insertOrReplace,
        );

        batch.insertAll(
          conversationHistoryTable,
          data
              .map(
                (e) => ConversationHistoryEntity(
                  userId: e.user.id,
                  lastInteractedAt: e.chat.sentTime,
                  chatId: e.chat.chatId,
                  lastMessage: e.chat.id,
                ),
              )
              .toList(),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  Future<void> insertLastChat(ChatModel chat) async {
    final data = await (select(
      conversationHistoryTable,
    )..where((e) => e.chatId.equals(chat.chatId))).getSingleOrNull();
    if (data != null && data.lastInteractedAt.isBefore(chat.sentTime)) {
      await (update(
        conversationHistoryTable,
      )..where((e) => e.chatId.equals(chat.chatId))).write(
        ConversationHistoryEntity(
          userId: data.userId,
          lastInteractedAt: chat.sentTime,
          chatId: chat.chatId,
          lastMessage: chat.id,
        ),
      );
    }
    // else {
    //   final user = await customSelect(
    //     'SELECT id FROM user_table WHERE id = ?',
    //     variables: [Variable.withString(chat.fromId)],
    //   ).getSingleOrNull();

    //   if (user == null) return;

    //   await into(conversationHistoryTable).insert(
    //     ConversationHistoryEntity(
    //       userId: chat.fromId,
    //       lastInteractedAt: chat.sentTime,
    //       chatId: chat.chatId,
    //       lastMessage: chat.id,
    //     ),
    //     mode: InsertMode.insertOrReplace,
    //   );
    // }
  }

  Stream<List<({UserModel user, ChatModel chat})>> getInteractedUserStream() {
    return (select(conversationHistoryTable)
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.lastInteractedAt,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(30))
        .join([
          innerJoin(
            userTable,
            userTable.id.equalsExp(conversationHistoryTable.userId),
          ),
          innerJoin(
            chatTable,
            chatTable.id.equalsExp(conversationHistoryTable.lastMessage),
          ),
        ])
        .watch()
        .map((rows) {
          return rows
              .map((row) {
                final chat = ChatModel.fromChatEntity(row.readTable(chatTable));
                final user = UserModel.fromUserEntity(row.readTable(userTable));
                return (user: user, chat: chat);
              })
              .whereType<({UserModel user, ChatModel chat})>()
              .toList();
        });
  }
}
