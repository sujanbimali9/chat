import 'package:chat/utils/database/table/chat_mixin.dart';
import 'package:drift/drift.dart';

@DataClassName('LastChatEntity')
@TableIndex(
  name: 'lastChatSentTimeIndex',
  unique: false,
  columns: {Symbol('sentTime')},
)
class LastChatTable extends Table with ChatMixin {
  @override
  Set<Column> get primaryKey => {chatId};
}
