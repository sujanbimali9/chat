import 'package:chat/utils/database/table/chat_mixin.dart';
import 'package:drift/drift.dart';

@DataClassName('ChatEntity')
@TableIndex(name: 'chatIdIndex1', columns: {#chatId})
@TableIndex(name: 'chatSentTimeIndex', columns: {#sentTime})
@TableIndex(name: 'statusIndex', columns: {#status})
@TableIndex(name: 'readIndex', columns: {#read})
@TableIndex(name: 'chatCompositeIndex', columns: {#chatId, #sentTime})
class ChatTable extends Table with ChatMixin {
  TextColumn get replyToId => text().nullable().references(ChatTable, #id)();
  @override
  Set<Column> get primaryKey => {id};
}
