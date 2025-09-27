import 'package:chat/utils/database/table/chat_table.dart';
import 'package:drift/drift.dart';

@DataClassName('UserEntity')
@TableIndex(name: 'nameIndex', unique: false, columns: {#name})
class UserTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get profileImage => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastActive => dateTime()();
  BoolColumn get showOnlineStatus => boolean()();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();
  TextColumn get phone => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ConversationHistoryEntity')
@TableIndex(name: 'userIdIndex', columns: {#userId})
@TableIndex(name: 'chatIdIndex', columns: {#chatId})
class ConversationHistoryTable extends Table {
  TextColumn get userId => text().references(UserTable, #id)();
  DateTimeColumn get lastInteractedAt => dateTime()();
  TextColumn get chatId => text()();
  TextColumn get lastMessage => text().references(ChatTable, #id).nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}
