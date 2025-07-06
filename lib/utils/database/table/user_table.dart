import 'package:drift/drift.dart';

@DataClassName('UserEntity')
@TableIndex(name: 'nameIndex', unique: false, columns: {Symbol('name')})
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
