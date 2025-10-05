import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:chat/utils/database/table/chat_table.dart';

part 'chat_table_query.g.dart';

@DriftAccessor(tables: [ChatTable])
class ChatTableQuery extends DatabaseAccessor<LocalDatabase>
    with _$ChatTableQueryMixin {
  ChatTableQuery(super.database);

  Future<ApiResponse<ChatModel, ChatPagination>> getChats(
    String chatId, {
    required int limit,
    required int? lastMessageSentTime,
  }) async {
    final cTable = alias(chatTable, 'chat');
    final rTable = alias(chatTable, 'reply');

    final chats =
        await (select(cTable)
              ..where(
                (tbl) =>
                    tbl.chatId.equals(chatId) &
                    tbl.sentTime.isSmallerThanValue(
                      lastMessageSentTime != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              lastMessageSentTime,
                            )
                          : DateTime.now(),
                    ),
              )
              ..limit(limit)
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.sentTime,
                  mode: OrderingMode.desc,
                ),
              ]))
            .join([
              leftOuterJoin(rTable, cTable.replyToId.equalsExp(rTable.id)),
            ])
            .map((row) {
              final mainChat = row.readTable(cTable);
              final replyChat = row.readTableOrNull(rTable);
              return ChatModel.fromChatEntity(mainChat).copyWith(
                replyTo: replyChat != null
                    ? ChatModel.fromChatEntity(replyChat)
                    : null,
              );
            })
            .get();

    final total = await countTotalChats(chatId);

    return ApiResponse(
      data: chats,
      message: 'Success',
      pagination: ChatPagination(
        limit: limit,
        lastMessageSentTime: chats.lastOrNull?.sentTime.millisecondsSinceEpoch,
        total: total,
      ),
      dataSource: ApiDataSource.local,
    );
  }

  Future<int> countTotalChats(String chatId) async {
    final countQuery = await customSelect(
      'SELECT COUNT(*) AS count FROM chat_table WHERE chat_id = ?',
      variables: [Variable.withString(chatId)],
    ).getSingle();
    return countQuery.data['count'] as int;
  }

  Future<List<ChatModel>> getPendingChats() async {
    final cTable = alias(chatTable, 'chat');
    final rTable = alias(chatTable, 'reply');

    final chats =
        await (select(cTable)
              ..where((tbl) => tbl.status.equals(MessageStatus.failed.name))
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.sentTime,
                  mode: OrderingMode.desc,
                ),
              ]))
            .join([
              leftOuterJoin(rTable, cTable.replyToId.equalsExp(rTable.id)),
            ])
            .map((row) {
              final mainChat = row.readTable(cTable);
              final replyChat = row.readTableOrNull(rTable);
              return ChatModel.fromChatEntity(mainChat).copyWith(
                replyTo: replyChat != null
                    ? ChatModel.fromChatEntity(replyChat)
                    : null,
              );
            })
            .get();
    return chats;
  }

  Future<void> insertChat(ChatModel chat) async {
    await transaction(() async {
      if (chat.replyTo != null) {
        final replyChatJson = chat.replyTo!.toJson();
        await into(chatTable).insert(
          ChatEntity.fromJson({
            ...replyChatJson,
            'medias': jsonEncode(replyChatJson['medias']),
          }),
          mode: InsertMode.insertOrIgnore,
        );
      }
      final chatJson = chat.toJson();
      await into(chatTable).insert(
        ChatEntity.fromJson({
          ...chatJson,
          'medias': jsonEncode(chatJson['medias']),
          'replyToId': chat.replyTo?.id,
        }),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> insertChats(List<ChatModel> chats) async {
    final List<ChatEntity> replyEntities = [];
    final List<ChatEntity> mainChatEntities = [];

    for (final chat in chats) {
      if (chat.replyTo != null) {
        final replyChatJson = chat.replyTo!.toJson();
        replyEntities.add(
          ChatEntity.fromJson({
            ...replyChatJson,
            'medias': jsonEncode(replyChatJson['medias']),
          }),
        );
      }
      final chatJson = chat.toJson();
      mainChatEntities.add(
        ChatEntity.fromJson({
          ...chatJson,
          'medias': jsonEncode(chatJson['medias']),
          'replyToId': chat.replyTo?.id,
        }),
      );
    }

    await batch((batch) {
      if (replyEntities.isNotEmpty) {
        batch.insertAll(
          chatTable,
          replyEntities,
          mode: InsertMode.insertOrIgnore,
        );
      }
      if (mainChatEntities.isNotEmpty) {
        batch.insertAll(
          chatTable,
          mainChatEntities,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> updateRead(String chatId) async {
    await (update(chatTable)..where((tbl) => tbl.chatId.equals(chatId))).write(
      const ChatTableCompanion(read: Value(true)),
    );
  }

  Future<void> deleteChat(String chatId) async {
    await (delete(chatTable)..where((tbl) => tbl.chatId.equals(chatId))).go();
  }

  Future<void> deleteAllChats() async {
    await transaction(() async {
      await delete(chatTable).go();
    });
  }

  Stream<List<ChatModel>> getChatsStream(String chatId) {
    final cTable = alias(chatTable, 'chat');
    final rTable = alias(chatTable, 'reply');

    final query =
        (select(cTable)
              ..where((tbl) => tbl.chatId.equals(chatId))
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.sentTime,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(10))
            .join([
              leftOuterJoin(rTable, cTable.replyToId.equalsExp(rTable.id)),
            ])
            .watch()
            .map((rows) {
              return rows.map((row) {
                final mainChat = row.readTable(cTable);
                final replyChat = row.readTableOrNull(rTable);
                return ChatModel.fromChatEntity(mainChat).copyWith(
                  replyTo: replyChat != null
                      ? ChatModel.fromChatEntity(replyChat)
                      : null,
                );
              }).toList();
            });

    return query;
  }
}
