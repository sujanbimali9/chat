import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/utils/database/converter/converter.dart';
import 'package:drift/drift.dart';

@DataClassName('ChatEntity')
@TableIndex(name: 'chatIdIndex1', columns: {#chatId})
@TableIndex(name: 'chatSentTimeIndex', columns: {#sentTime})
@TableIndex(name: 'statusIndex', columns: {#status})
@TableIndex(name: 'readIndex', columns: {#read})
@TableIndex(name: 'chatCompositeIndex', columns: {#chatId, #sentTime})
class ChatTable extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text()();
  TextColumn get msg => text()();
  BoolColumn get read => boolean()();
  TextColumn get type => text().map(const EnumNameConverter(ChatType.values))();
  TextColumn get toId => text()();
  TextColumn get fromId => text()();
  DateTimeColumn get readTime => dateTime().nullable()();
  DateTimeColumn get sentTime => dateTime()();
  TextColumn get medias => text().map(const MediaConverter())();
  TextColumn get status =>
      text().map(const EnumNameConverter(MessageStatus.values))();
  TextColumn get replyToId => text().nullable().references(ChatTable, #id)();
  @override
  Set<Column> get primaryKey => {id};
}
