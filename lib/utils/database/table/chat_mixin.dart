import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/utils/database/converter/converter.dart';
import 'package:drift/drift.dart';

mixin ChatMixin on Table {
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
}
