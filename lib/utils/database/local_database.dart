import 'dart:io';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/data/model/media_model.dart';

import 'package:chat/utils/database/converter/converter.dart';
import 'package:chat/utils/database/daos/last_chat_table_query.dart';
import 'package:chat/utils/database/daos/user_table_query.dart';
import 'package:chat/utils/database/table/chat_table.dart';
import 'package:chat/utils/database/daos/chat_table_query.dart';
import 'package:chat/utils/database/table/last_chat_table.dart';
import 'package:chat/utils/database/table/user_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/chat.db');
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [UserTable, ChatTable, LastChatTable],
  daos: [
    ChatTableQuery,
    LastChatTableQuery,
    UserTableQuery,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> deleteAll() async {
    transaction(() async {
      await delete(userTable).go();
      await delete(chatTable).go();
      await delete(lastChatTable).go();
    });
  }
}
