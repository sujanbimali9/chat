import 'dart:convert';

import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:chat/utils/database/table/last_chat_table.dart';
import 'package:drift/drift.dart';

part 'last_chat_table_query.g.dart';

@DriftAccessor(tables: [LastChatTable])
class LastChatTableQuery extends DatabaseAccessor<LocalDatabase>
    with _$LastChatTableQueryMixin {
  LastChatTableQuery(super.db);

  Future<void> insertLastChat(ChatModel chat) async {
    final chatJson = chat.toJson();
    await into(lastChatTable).insertOnConflictUpdate(
      LastChatEntity.fromJson({
        ...chatJson,
        'medias': jsonEncode(chatJson['medias']),
      }),
    );
  }

  Future<void> insertLastChats(List<ChatModel> chats) async {
    final lastChatEntities = chats.map((chat) {
      final chatJson = chat.toJson();
      return LastChatEntity.fromJson({
        ...chatJson,
        'medias': jsonEncode(chatJson['medias']),
      });
    });

    await batch((batch) {
      batch.insertAll(
        lastChatTable,
        lastChatEntities,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> deleteLastChat(String chatId) async {
    await (delete(lastChatTable)..where((tbl) => tbl.chatId.equals(chatId)))
        .go();
  }

  Future<void> deleteAllLastChats() async {
    await delete(lastChatTable).go();
  }

  Stream<List<ChatModel>> getLastChatsStream({int? limit, int? offset}) {
    final chatsStream = (select(lastChatTable)
          ..limit(limit ?? 20, offset: offset)
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.sentTime, mode: OrderingMode.desc)
          ]))
        .watch();
    return chatsStream
        .map((event) => event.map(ChatModel.fromLastChatEntity).toList());
  }

  Future<ApiResponse<ChatModel>> getLastChats(
      {required int limit, required int offset}) async {
    final chats = await (select(lastChatTable)
          ..limit(limit, offset: offset)
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.sentTime, mode: OrderingMode.desc)
          ]))
        .get();
    final total = await countTotalLastChats();
    return ApiResponse(
      data: chats.map(ChatModel.fromLastChatEntity).toList(),
      pagination:
          Pagination(offset: offset + chats.length, limit: limit, total: total),
      dataSource: ApiDataSource.local,
    );
  }

  Future<int> countTotalLastChats() async {
    final result = await customSelect(
      'SELECT COUNT(*) as count FROM last_chat_table',
      readsFrom: {lastChatTable},
    ).getSingle();

    return result.data['count'] as int;
  }
}
