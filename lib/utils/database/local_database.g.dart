// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profileImageMeta =
      const VerificationMeta('profileImage');
  @override
  late final GeneratedColumn<String> profileImage = GeneratedColumn<String>(
      'profile_image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastActiveMeta =
      const VerificationMeta('lastActive');
  @override
  late final GeneratedColumn<DateTime> lastActive = GeneratedColumn<DateTime>(
      'last_active', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _showOnlineStatusMeta =
      const VerificationMeta('showOnlineStatus');
  @override
  late final GeneratedColumn<bool> showOnlineStatus = GeneratedColumn<bool>(
      'show_online_status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_online_status" IN (0, 1))'));
  static const VerificationMeta _isOnlineMeta =
      const VerificationMeta('isOnline');
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
      'is_online', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_online" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        email,
        profileImage,
        createdAt,
        lastActive,
        showOnlineStatus,
        isOnline,
        phone
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('profile_image')) {
      context.handle(
          _profileImageMeta,
          profileImage.isAcceptableOrUnknown(
              data['profile_image']!, _profileImageMeta));
    } else if (isInserting) {
      context.missing(_profileImageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_active')) {
      context.handle(
          _lastActiveMeta,
          lastActive.isAcceptableOrUnknown(
              data['last_active']!, _lastActiveMeta));
    } else if (isInserting) {
      context.missing(_lastActiveMeta);
    }
    if (data.containsKey('show_online_status')) {
      context.handle(
          _showOnlineStatusMeta,
          showOnlineStatus.isAcceptableOrUnknown(
              data['show_online_status']!, _showOnlineStatusMeta));
    } else if (isInserting) {
      context.missing(_showOnlineStatusMeta);
    }
    if (data.containsKey('is_online')) {
      context.handle(_isOnlineMeta,
          isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      profileImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_image'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastActive: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_active'])!,
      showOnlineStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_online_status'])!,
      isOnline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_online'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  final String id;
  final String name;
  final String? email;
  final String profileImage;
  final DateTime createdAt;
  final DateTime lastActive;
  final bool showOnlineStatus;
  final bool isOnline;
  final String? phone;
  const UserEntity(
      {required this.id,
      required this.name,
      this.email,
      required this.profileImage,
      required this.createdAt,
      required this.lastActive,
      required this.showOnlineStatus,
      required this.isOnline,
      this.phone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['profile_image'] = Variable<String>(profileImage);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_active'] = Variable<DateTime>(lastActive);
    map['show_online_status'] = Variable<bool>(showOnlineStatus);
    map['is_online'] = Variable<bool>(isOnline);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      name: Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      profileImage: Value(profileImage),
      createdAt: Value(createdAt),
      lastActive: Value(lastActive),
      showOnlineStatus: Value(showOnlineStatus),
      isOnline: Value(isOnline),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      profileImage: serializer.fromJson<String>(json['profileImage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastActive: serializer.fromJson<DateTime>(json['lastActive']),
      showOnlineStatus: serializer.fromJson<bool>(json['showOnlineStatus']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      phone: serializer.fromJson<String?>(json['phone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'profileImage': serializer.toJson<String>(profileImage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastActive': serializer.toJson<DateTime>(lastActive),
      'showOnlineStatus': serializer.toJson<bool>(showOnlineStatus),
      'isOnline': serializer.toJson<bool>(isOnline),
      'phone': serializer.toJson<String?>(phone),
    };
  }

  UserEntity copyWith(
          {String? id,
          String? name,
          Value<String?> email = const Value.absent(),
          String? profileImage,
          DateTime? createdAt,
          DateTime? lastActive,
          bool? showOnlineStatus,
          bool? isOnline,
          Value<String?> phone = const Value.absent()}) =>
      UserEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email.present ? email.value : this.email,
        profileImage: profileImage ?? this.profileImage,
        createdAt: createdAt ?? this.createdAt,
        lastActive: lastActive ?? this.lastActive,
        showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
        isOnline: isOnline ?? this.isOnline,
        phone: phone.present ? phone.value : this.phone,
      );
  UserEntity copyWithCompanion(UserTableCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      profileImage: data.profileImage.present
          ? data.profileImage.value
          : this.profileImage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastActive:
          data.lastActive.present ? data.lastActive.value : this.lastActive,
      showOnlineStatus: data.showOnlineStatus.present
          ? data.showOnlineStatus.value
          : this.showOnlineStatus,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      phone: data.phone.present ? data.phone.value : this.phone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('profileImage: $profileImage, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastActive: $lastActive, ')
          ..write('showOnlineStatus: $showOnlineStatus, ')
          ..write('isOnline: $isOnline, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, profileImage, createdAt,
      lastActive, showOnlineStatus, isOnline, phone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.profileImage == this.profileImage &&
          other.createdAt == this.createdAt &&
          other.lastActive == this.lastActive &&
          other.showOnlineStatus == this.showOnlineStatus &&
          other.isOnline == this.isOnline &&
          other.phone == this.phone);
}

class UserTableCompanion extends UpdateCompanion<UserEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> email;
  final Value<String> profileImage;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastActive;
  final Value<bool> showOnlineStatus;
  final Value<bool> isOnline;
  final Value<String?> phone;
  final Value<int> rowid;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.showOnlineStatus = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.phone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String id,
    required String name,
    this.email = const Value.absent(),
    required String profileImage,
    required DateTime createdAt,
    required DateTime lastActive,
    required bool showOnlineStatus,
    this.isOnline = const Value.absent(),
    this.phone = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        profileImage = Value(profileImage),
        createdAt = Value(createdAt),
        lastActive = Value(lastActive),
        showOnlineStatus = Value(showOnlineStatus);
  static Insertable<UserEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? profileImage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastActive,
    Expression<bool>? showOnlineStatus,
    Expression<bool>? isOnline,
    Expression<String>? phone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (profileImage != null) 'profile_image': profileImage,
      if (createdAt != null) 'created_at': createdAt,
      if (lastActive != null) 'last_active': lastActive,
      if (showOnlineStatus != null) 'show_online_status': showOnlineStatus,
      if (isOnline != null) 'is_online': isOnline,
      if (phone != null) 'phone': phone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? email,
      Value<String>? profileImage,
      Value<DateTime>? createdAt,
      Value<DateTime>? lastActive,
      Value<bool>? showOnlineStatus,
      Value<bool>? isOnline,
      Value<String?>? phone,
      Value<int>? rowid}) {
    return UserTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      isOnline: isOnline ?? this.isOnline,
      phone: phone ?? this.phone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (profileImage.present) {
      map['profile_image'] = Variable<String>(profileImage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastActive.present) {
      map['last_active'] = Variable<DateTime>(lastActive.value);
    }
    if (showOnlineStatus.present) {
      map['show_online_status'] = Variable<bool>(showOnlineStatus.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('profileImage: $profileImage, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastActive: $lastActive, ')
          ..write('showOnlineStatus: $showOnlineStatus, ')
          ..write('isOnline: $isOnline, ')
          ..write('phone: $phone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatTableTable extends ChatTable
    with TableInfo<$ChatTableTable, ChatEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _msgMeta = const VerificationMeta('msg');
  @override
  late final GeneratedColumn<String> msg = GeneratedColumn<String>(
      'msg', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
      'read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("read" IN (0, 1))'));
  @override
  late final GeneratedColumnWithTypeConverter<ChatType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<ChatType>($ChatTableTable.$convertertype);
  static const VerificationMeta _toIdMeta = const VerificationMeta('toId');
  @override
  late final GeneratedColumn<String> toId = GeneratedColumn<String>(
      'to_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  @override
  late final GeneratedColumn<String> fromId = GeneratedColumn<String>(
      'from_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _readTimeMeta =
      const VerificationMeta('readTime');
  @override
  late final GeneratedColumn<DateTime> readTime = GeneratedColumn<DateTime>(
      'read_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sentTimeMeta =
      const VerificationMeta('sentTime');
  @override
  late final GeneratedColumn<DateTime> sentTime = GeneratedColumn<DateTime>(
      'sent_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<MediaModel>, String> medias =
      GeneratedColumn<String>('medias', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<MediaModel>>($ChatTableTable.$convertermedias);
  @override
  late final GeneratedColumnWithTypeConverter<MessageStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<MessageStatus>($ChatTableTable.$converterstatus);
  static const VerificationMeta _replyToIdMeta =
      const VerificationMeta('replyToId');
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
      'reply_to_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chat_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        chatId,
        msg,
        read,
        type,
        toId,
        fromId,
        readTime,
        sentTime,
        medias,
        status,
        replyToId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChatEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('msg')) {
      context.handle(
          _msgMeta, msg.isAcceptableOrUnknown(data['msg']!, _msgMeta));
    } else if (isInserting) {
      context.missing(_msgMeta);
    }
    if (data.containsKey('read')) {
      context.handle(
          _readMeta, read.isAcceptableOrUnknown(data['read']!, _readMeta));
    } else if (isInserting) {
      context.missing(_readMeta);
    }
    if (data.containsKey('to_id')) {
      context.handle(
          _toIdMeta, toId.isAcceptableOrUnknown(data['to_id']!, _toIdMeta));
    } else if (isInserting) {
      context.missing(_toIdMeta);
    }
    if (data.containsKey('from_id')) {
      context.handle(_fromIdMeta,
          fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta));
    } else if (isInserting) {
      context.missing(_fromIdMeta);
    }
    if (data.containsKey('read_time')) {
      context.handle(_readTimeMeta,
          readTime.isAcceptableOrUnknown(data['read_time']!, _readTimeMeta));
    }
    if (data.containsKey('sent_time')) {
      context.handle(_sentTimeMeta,
          sentTime.isAcceptableOrUnknown(data['sent_time']!, _sentTimeMeta));
    } else if (isInserting) {
      context.missing(_sentTimeMeta);
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
          _replyToIdMeta,
          replyToId.isAcceptableOrUnknown(
              data['reply_to_id']!, _replyToIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      msg: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}msg'])!,
      read: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}read'])!,
      type: $ChatTableTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      toId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_id'])!,
      fromId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_id'])!,
      readTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_time']),
      sentTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_time'])!,
      medias: $ChatTableTable.$convertermedias.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medias'])!),
      status: $ChatTableTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      replyToId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reply_to_id']),
    );
  }

  @override
  $ChatTableTable createAlias(String alias) {
    return $ChatTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChatType, String, String> $convertertype =
      const EnumNameConverter(ChatType.values);
  static JsonTypeConverter2<List<MediaModel>, String, String> $convertermedias =
      const MediaConverter();
  static JsonTypeConverter2<MessageStatus, String, String> $converterstatus =
      const EnumNameConverter(MessageStatus.values);
}

class ChatEntity extends DataClass implements Insertable<ChatEntity> {
  final String id;
  final String chatId;
  final String msg;
  final bool read;
  final ChatType type;
  final String toId;
  final String fromId;
  final DateTime? readTime;
  final DateTime sentTime;
  final List<MediaModel> medias;
  final MessageStatus status;
  final String? replyToId;
  const ChatEntity(
      {required this.id,
      required this.chatId,
      required this.msg,
      required this.read,
      required this.type,
      required this.toId,
      required this.fromId,
      this.readTime,
      required this.sentTime,
      required this.medias,
      required this.status,
      this.replyToId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chat_id'] = Variable<String>(chatId);
    map['msg'] = Variable<String>(msg);
    map['read'] = Variable<bool>(read);
    {
      map['type'] =
          Variable<String>($ChatTableTable.$convertertype.toSql(type));
    }
    map['to_id'] = Variable<String>(toId);
    map['from_id'] = Variable<String>(fromId);
    if (!nullToAbsent || readTime != null) {
      map['read_time'] = Variable<DateTime>(readTime);
    }
    map['sent_time'] = Variable<DateTime>(sentTime);
    {
      map['medias'] =
          Variable<String>($ChatTableTable.$convertermedias.toSql(medias));
    }
    {
      map['status'] =
          Variable<String>($ChatTableTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    return map;
  }

  ChatTableCompanion toCompanion(bool nullToAbsent) {
    return ChatTableCompanion(
      id: Value(id),
      chatId: Value(chatId),
      msg: Value(msg),
      read: Value(read),
      type: Value(type),
      toId: Value(toId),
      fromId: Value(fromId),
      readTime: readTime == null && nullToAbsent
          ? const Value.absent()
          : Value(readTime),
      sentTime: Value(sentTime),
      medias: Value(medias),
      status: Value(status),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
    );
  }

  factory ChatEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatEntity(
      id: serializer.fromJson<String>(json['id']),
      chatId: serializer.fromJson<String>(json['chatId']),
      msg: serializer.fromJson<String>(json['msg']),
      read: serializer.fromJson<bool>(json['read']),
      type: $ChatTableTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      toId: serializer.fromJson<String>(json['toId']),
      fromId: serializer.fromJson<String>(json['fromId']),
      readTime: serializer.fromJson<DateTime?>(json['readTime']),
      sentTime: serializer.fromJson<DateTime>(json['sentTime']),
      medias: $ChatTableTable.$convertermedias
          .fromJson(serializer.fromJson<String>(json['medias'])),
      status: $ChatTableTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chatId': serializer.toJson<String>(chatId),
      'msg': serializer.toJson<String>(msg),
      'read': serializer.toJson<bool>(read),
      'type': serializer
          .toJson<String>($ChatTableTable.$convertertype.toJson(type)),
      'toId': serializer.toJson<String>(toId),
      'fromId': serializer.toJson<String>(fromId),
      'readTime': serializer.toJson<DateTime?>(readTime),
      'sentTime': serializer.toJson<DateTime>(sentTime),
      'medias': serializer
          .toJson<String>($ChatTableTable.$convertermedias.toJson(medias)),
      'status': serializer
          .toJson<String>($ChatTableTable.$converterstatus.toJson(status)),
      'replyToId': serializer.toJson<String?>(replyToId),
    };
  }

  ChatEntity copyWith(
          {String? id,
          String? chatId,
          String? msg,
          bool? read,
          ChatType? type,
          String? toId,
          String? fromId,
          Value<DateTime?> readTime = const Value.absent(),
          DateTime? sentTime,
          List<MediaModel>? medias,
          MessageStatus? status,
          Value<String?> replyToId = const Value.absent()}) =>
      ChatEntity(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        msg: msg ?? this.msg,
        read: read ?? this.read,
        type: type ?? this.type,
        toId: toId ?? this.toId,
        fromId: fromId ?? this.fromId,
        readTime: readTime.present ? readTime.value : this.readTime,
        sentTime: sentTime ?? this.sentTime,
        medias: medias ?? this.medias,
        status: status ?? this.status,
        replyToId: replyToId.present ? replyToId.value : this.replyToId,
      );
  ChatEntity copyWithCompanion(ChatTableCompanion data) {
    return ChatEntity(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      msg: data.msg.present ? data.msg.value : this.msg,
      read: data.read.present ? data.read.value : this.read,
      type: data.type.present ? data.type.value : this.type,
      toId: data.toId.present ? data.toId.value : this.toId,
      fromId: data.fromId.present ? data.fromId.value : this.fromId,
      readTime: data.readTime.present ? data.readTime.value : this.readTime,
      sentTime: data.sentTime.present ? data.sentTime.value : this.sentTime,
      medias: data.medias.present ? data.medias.value : this.medias,
      status: data.status.present ? data.status.value : this.status,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatEntity(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('msg: $msg, ')
          ..write('read: $read, ')
          ..write('type: $type, ')
          ..write('toId: $toId, ')
          ..write('fromId: $fromId, ')
          ..write('readTime: $readTime, ')
          ..write('sentTime: $sentTime, ')
          ..write('medias: $medias, ')
          ..write('status: $status, ')
          ..write('replyToId: $replyToId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chatId, msg, read, type, toId, fromId,
      readTime, sentTime, medias, status, replyToId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatEntity &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.msg == this.msg &&
          other.read == this.read &&
          other.type == this.type &&
          other.toId == this.toId &&
          other.fromId == this.fromId &&
          other.readTime == this.readTime &&
          other.sentTime == this.sentTime &&
          other.medias == this.medias &&
          other.status == this.status &&
          other.replyToId == this.replyToId);
}

class ChatTableCompanion extends UpdateCompanion<ChatEntity> {
  final Value<String> id;
  final Value<String> chatId;
  final Value<String> msg;
  final Value<bool> read;
  final Value<ChatType> type;
  final Value<String> toId;
  final Value<String> fromId;
  final Value<DateTime?> readTime;
  final Value<DateTime> sentTime;
  final Value<List<MediaModel>> medias;
  final Value<MessageStatus> status;
  final Value<String?> replyToId;
  final Value<int> rowid;
  const ChatTableCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.msg = const Value.absent(),
    this.read = const Value.absent(),
    this.type = const Value.absent(),
    this.toId = const Value.absent(),
    this.fromId = const Value.absent(),
    this.readTime = const Value.absent(),
    this.sentTime = const Value.absent(),
    this.medias = const Value.absent(),
    this.status = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatTableCompanion.insert({
    required String id,
    required String chatId,
    required String msg,
    required bool read,
    required ChatType type,
    required String toId,
    required String fromId,
    this.readTime = const Value.absent(),
    required DateTime sentTime,
    required List<MediaModel> medias,
    required MessageStatus status,
    this.replyToId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chatId = Value(chatId),
        msg = Value(msg),
        read = Value(read),
        type = Value(type),
        toId = Value(toId),
        fromId = Value(fromId),
        sentTime = Value(sentTime),
        medias = Value(medias),
        status = Value(status);
  static Insertable<ChatEntity> custom({
    Expression<String>? id,
    Expression<String>? chatId,
    Expression<String>? msg,
    Expression<bool>? read,
    Expression<String>? type,
    Expression<String>? toId,
    Expression<String>? fromId,
    Expression<DateTime>? readTime,
    Expression<DateTime>? sentTime,
    Expression<String>? medias,
    Expression<String>? status,
    Expression<String>? replyToId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (msg != null) 'msg': msg,
      if (read != null) 'read': read,
      if (type != null) 'type': type,
      if (toId != null) 'to_id': toId,
      if (fromId != null) 'from_id': fromId,
      if (readTime != null) 'read_time': readTime,
      if (sentTime != null) 'sent_time': sentTime,
      if (medias != null) 'medias': medias,
      if (status != null) 'status': status,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? chatId,
      Value<String>? msg,
      Value<bool>? read,
      Value<ChatType>? type,
      Value<String>? toId,
      Value<String>? fromId,
      Value<DateTime?>? readTime,
      Value<DateTime>? sentTime,
      Value<List<MediaModel>>? medias,
      Value<MessageStatus>? status,
      Value<String?>? replyToId,
      Value<int>? rowid}) {
    return ChatTableCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      msg: msg ?? this.msg,
      read: read ?? this.read,
      type: type ?? this.type,
      toId: toId ?? this.toId,
      fromId: fromId ?? this.fromId,
      readTime: readTime ?? this.readTime,
      sentTime: sentTime ?? this.sentTime,
      medias: medias ?? this.medias,
      status: status ?? this.status,
      replyToId: replyToId ?? this.replyToId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (msg.present) {
      map['msg'] = Variable<String>(msg.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($ChatTableTable.$convertertype.toSql(type.value));
    }
    if (toId.present) {
      map['to_id'] = Variable<String>(toId.value);
    }
    if (fromId.present) {
      map['from_id'] = Variable<String>(fromId.value);
    }
    if (readTime.present) {
      map['read_time'] = Variable<DateTime>(readTime.value);
    }
    if (sentTime.present) {
      map['sent_time'] = Variable<DateTime>(sentTime.value);
    }
    if (medias.present) {
      map['medias'] = Variable<String>(
          $ChatTableTable.$convertermedias.toSql(medias.value));
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $ChatTableTable.$converterstatus.toSql(status.value));
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatTableCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('msg: $msg, ')
          ..write('read: $read, ')
          ..write('type: $type, ')
          ..write('toId: $toId, ')
          ..write('fromId: $fromId, ')
          ..write('readTime: $readTime, ')
          ..write('sentTime: $sentTime, ')
          ..write('medias: $medias, ')
          ..write('status: $status, ')
          ..write('replyToId: $replyToId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InteractedUserTableTable extends InteractedUserTable
    with TableInfo<$InteractedUserTableTable, InteractedUserEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InteractedUserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  static const VerificationMeta _lastInteractedAtMeta =
      const VerificationMeta('lastInteractedAt');
  @override
  late final GeneratedColumn<DateTime> lastInteractedAt =
      GeneratedColumn<DateTime>('last_interacted_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastMessageMeta =
      const VerificationMeta('lastMessage');
  @override
  late final GeneratedColumn<String> lastMessage = GeneratedColumn<String>(
      'last_message', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chat_table (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [userId, lastInteractedAt, chatId, lastMessage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interacted_user_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<InteractedUserEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('last_interacted_at')) {
      context.handle(
          _lastInteractedAtMeta,
          lastInteractedAt.isAcceptableOrUnknown(
              data['last_interacted_at']!, _lastInteractedAtMeta));
    } else if (isInserting) {
      context.missing(_lastInteractedAtMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('last_message')) {
      context.handle(
          _lastMessageMeta,
          lastMessage.isAcceptableOrUnknown(
              data['last_message']!, _lastMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  InteractedUserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InteractedUserEntity(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      lastInteractedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_interacted_at'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      lastMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_message']),
    );
  }

  @override
  $InteractedUserTableTable createAlias(String alias) {
    return $InteractedUserTableTable(attachedDatabase, alias);
  }
}

class InteractedUserEntity extends DataClass
    implements Insertable<InteractedUserEntity> {
  final String userId;
  final DateTime lastInteractedAt;
  final String chatId;
  final String? lastMessage;
  const InteractedUserEntity(
      {required this.userId,
      required this.lastInteractedAt,
      required this.chatId,
      this.lastMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['last_interacted_at'] = Variable<DateTime>(lastInteractedAt);
    map['chat_id'] = Variable<String>(chatId);
    if (!nullToAbsent || lastMessage != null) {
      map['last_message'] = Variable<String>(lastMessage);
    }
    return map;
  }

  InteractedUserTableCompanion toCompanion(bool nullToAbsent) {
    return InteractedUserTableCompanion(
      userId: Value(userId),
      lastInteractedAt: Value(lastInteractedAt),
      chatId: Value(chatId),
      lastMessage: lastMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage),
    );
  }

  factory InteractedUserEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InteractedUserEntity(
      userId: serializer.fromJson<String>(json['userId']),
      lastInteractedAt: serializer.fromJson<DateTime>(json['lastInteractedAt']),
      chatId: serializer.fromJson<String>(json['chatId']),
      lastMessage: serializer.fromJson<String?>(json['lastMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'lastInteractedAt': serializer.toJson<DateTime>(lastInteractedAt),
      'chatId': serializer.toJson<String>(chatId),
      'lastMessage': serializer.toJson<String?>(lastMessage),
    };
  }

  InteractedUserEntity copyWith(
          {String? userId,
          DateTime? lastInteractedAt,
          String? chatId,
          Value<String?> lastMessage = const Value.absent()}) =>
      InteractedUserEntity(
        userId: userId ?? this.userId,
        lastInteractedAt: lastInteractedAt ?? this.lastInteractedAt,
        chatId: chatId ?? this.chatId,
        lastMessage: lastMessage.present ? lastMessage.value : this.lastMessage,
      );
  InteractedUserEntity copyWithCompanion(InteractedUserTableCompanion data) {
    return InteractedUserEntity(
      userId: data.userId.present ? data.userId.value : this.userId,
      lastInteractedAt: data.lastInteractedAt.present
          ? data.lastInteractedAt.value
          : this.lastInteractedAt,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      lastMessage:
          data.lastMessage.present ? data.lastMessage.value : this.lastMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InteractedUserEntity(')
          ..write('userId: $userId, ')
          ..write('lastInteractedAt: $lastInteractedAt, ')
          ..write('chatId: $chatId, ')
          ..write('lastMessage: $lastMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, lastInteractedAt, chatId, lastMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InteractedUserEntity &&
          other.userId == this.userId &&
          other.lastInteractedAt == this.lastInteractedAt &&
          other.chatId == this.chatId &&
          other.lastMessage == this.lastMessage);
}

class InteractedUserTableCompanion
    extends UpdateCompanion<InteractedUserEntity> {
  final Value<String> userId;
  final Value<DateTime> lastInteractedAt;
  final Value<String> chatId;
  final Value<String?> lastMessage;
  final Value<int> rowid;
  const InteractedUserTableCompanion({
    this.userId = const Value.absent(),
    this.lastInteractedAt = const Value.absent(),
    this.chatId = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InteractedUserTableCompanion.insert({
    required String userId,
    required DateTime lastInteractedAt,
    required String chatId,
    this.lastMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        lastInteractedAt = Value(lastInteractedAt),
        chatId = Value(chatId);
  static Insertable<InteractedUserEntity> custom({
    Expression<String>? userId,
    Expression<DateTime>? lastInteractedAt,
    Expression<String>? chatId,
    Expression<String>? lastMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (lastInteractedAt != null) 'last_interacted_at': lastInteractedAt,
      if (chatId != null) 'chat_id': chatId,
      if (lastMessage != null) 'last_message': lastMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InteractedUserTableCompanion copyWith(
      {Value<String>? userId,
      Value<DateTime>? lastInteractedAt,
      Value<String>? chatId,
      Value<String?>? lastMessage,
      Value<int>? rowid}) {
    return InteractedUserTableCompanion(
      userId: userId ?? this.userId,
      lastInteractedAt: lastInteractedAt ?? this.lastInteractedAt,
      chatId: chatId ?? this.chatId,
      lastMessage: lastMessage ?? this.lastMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lastInteractedAt.present) {
      map['last_interacted_at'] = Variable<DateTime>(lastInteractedAt.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (lastMessage.present) {
      map['last_message'] = Variable<String>(lastMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InteractedUserTableCompanion(')
          ..write('userId: $userId, ')
          ..write('lastInteractedAt: $lastInteractedAt, ')
          ..write('chatId: $chatId, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $ChatTableTable chatTable = $ChatTableTable(this);
  late final $InteractedUserTableTable interactedUserTable =
      $InteractedUserTableTable(this);
  late final Index ncameIndex =
      Index('ncameIndex', 'CREATE INDEX ncameIndex ON user_table (name)');
  late final Index chatIdIndex1 = Index(
      'chatIdIndex1', 'CREATE INDEX chatIdIndex1 ON chat_table (chat_id)');
  late final Index chatSentTimeIndex = Index('chatSentTimeIndex',
      'CREATE INDEX chatSentTimeIndex ON chat_table (sent_time)');
  late final Index statusIndex =
      Index('statusIndex', 'CREATE INDEX statusIndex ON chat_table (status)');
  late final Index readIndex =
      Index('readIndex', 'CREATE INDEX readIndex ON chat_table (read)');
  late final Index chatCompositeIndex = Index('chatCompositeIndex',
      'CREATE INDEX chatCompositeIndex ON chat_table (chat_id, sent_time)');
  late final Index userIdIndex = Index('userIdIndex',
      'CREATE INDEX userIdIndex ON interacted_user_table (user_id)');
  late final Index chatIdIndex = Index('chatIdIndex',
      'CREATE INDEX chatIdIndex ON interacted_user_table (chat_id)');
  late final ChatTableQuery chatTableQuery =
      ChatTableQuery(this as LocalDatabase);
  late final UserTableQuery userTableQuery =
      UserTableQuery(this as LocalDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userTable,
        chatTable,
        interactedUserTable,
        ncameIndex,
        chatIdIndex1,
        chatSentTimeIndex,
        statusIndex,
        readIndex,
        chatCompositeIndex,
        userIdIndex,
        chatIdIndex
      ];
}

typedef $$UserTableTableCreateCompanionBuilder = UserTableCompanion Function({
  required String id,
  required String name,
  Value<String?> email,
  required String profileImage,
  required DateTime createdAt,
  required DateTime lastActive,
  required bool showOnlineStatus,
  Value<bool> isOnline,
  Value<String?> phone,
  Value<int> rowid,
});
typedef $$UserTableTableUpdateCompanionBuilder = UserTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> email,
  Value<String> profileImage,
  Value<DateTime> createdAt,
  Value<DateTime> lastActive,
  Value<bool> showOnlineStatus,
  Value<bool> isOnline,
  Value<String?> phone,
  Value<int> rowid,
});

final class $$UserTableTableReferences
    extends BaseReferences<_$LocalDatabase, $UserTableTable, UserEntity> {
  $$UserTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InteractedUserTableTable,
      List<InteractedUserEntity>> _interactedUserTableRefsTable(
          _$LocalDatabase db) =>
      MultiTypedResultKey.fromTable(db.interactedUserTable,
          aliasName: $_aliasNameGenerator(
              db.userTable.id, db.interactedUserTable.userId));

  $$InteractedUserTableTableProcessedTableManager get interactedUserTableRefs {
    final manager =
        $$InteractedUserTableTableTableManager($_db, $_db.interactedUserTable)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_interactedUserTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UserTableTableFilterComposer
    extends Composer<_$LocalDatabase, $UserTableTable> {
  $$UserTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileImage => $composableBuilder(
      column: $table.profileImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastActive => $composableBuilder(
      column: $table.lastActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showOnlineStatus => $composableBuilder(
      column: $table.showOnlineStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOnline => $composableBuilder(
      column: $table.isOnline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  Expression<bool> interactedUserTableRefs(
      Expression<bool> Function($$InteractedUserTableTableFilterComposer f) f) {
    final $$InteractedUserTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.interactedUserTable,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InteractedUserTableTableFilterComposer(
              $db: $db,
              $table: $db.interactedUserTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UserTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $UserTableTable> {
  $$UserTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileImage => $composableBuilder(
      column: $table.profileImage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastActive => $composableBuilder(
      column: $table.lastActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showOnlineStatus => $composableBuilder(
      column: $table.showOnlineStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOnline => $composableBuilder(
      column: $table.isOnline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get profileImage => $composableBuilder(
      column: $table.profileImage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActive => $composableBuilder(
      column: $table.lastActive, builder: (column) => column);

  GeneratedColumn<bool> get showOnlineStatus => $composableBuilder(
      column: $table.showOnlineStatus, builder: (column) => column);

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  Expression<T> interactedUserTableRefs<T extends Object>(
      Expression<T> Function($$InteractedUserTableTableAnnotationComposer a)
          f) {
    final $$InteractedUserTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.interactedUserTable,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InteractedUserTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.interactedUserTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$UserTableTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $UserTableTable,
    UserEntity,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableAnnotationComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (UserEntity, $$UserTableTableReferences),
    UserEntity,
    PrefetchHooks Function({bool interactedUserTableRefs})> {
  $$UserTableTableTableManager(_$LocalDatabase db, $UserTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String> profileImage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> lastActive = const Value.absent(),
            Value<bool> showOnlineStatus = const Value.absent(),
            Value<bool> isOnline = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTableCompanion(
            id: id,
            name: name,
            email: email,
            profileImage: profileImage,
            createdAt: createdAt,
            lastActive: lastActive,
            showOnlineStatus: showOnlineStatus,
            isOnline: isOnline,
            phone: phone,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> email = const Value.absent(),
            required String profileImage,
            required DateTime createdAt,
            required DateTime lastActive,
            required bool showOnlineStatus,
            Value<bool> isOnline = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTableCompanion.insert(
            id: id,
            name: name,
            email: email,
            profileImage: profileImage,
            createdAt: createdAt,
            lastActive: lastActive,
            showOnlineStatus: showOnlineStatus,
            isOnline: isOnline,
            phone: phone,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({interactedUserTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (interactedUserTableRefs) db.interactedUserTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (interactedUserTableRefs)
                    await $_getPrefetchedData<UserEntity, $UserTableTable, InteractedUserEntity>(
                        currentTable: table,
                        referencedTable: $$UserTableTableReferences
                            ._interactedUserTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UserTableTableReferences(db, table, p0)
                                .interactedUserTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UserTableTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $UserTableTable,
    UserEntity,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableAnnotationComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (UserEntity, $$UserTableTableReferences),
    UserEntity,
    PrefetchHooks Function({bool interactedUserTableRefs})>;
typedef $$ChatTableTableCreateCompanionBuilder = ChatTableCompanion Function({
  required String id,
  required String chatId,
  required String msg,
  required bool read,
  required ChatType type,
  required String toId,
  required String fromId,
  Value<DateTime?> readTime,
  required DateTime sentTime,
  required List<MediaModel> medias,
  required MessageStatus status,
  Value<String?> replyToId,
  Value<int> rowid,
});
typedef $$ChatTableTableUpdateCompanionBuilder = ChatTableCompanion Function({
  Value<String> id,
  Value<String> chatId,
  Value<String> msg,
  Value<bool> read,
  Value<ChatType> type,
  Value<String> toId,
  Value<String> fromId,
  Value<DateTime?> readTime,
  Value<DateTime> sentTime,
  Value<List<MediaModel>> medias,
  Value<MessageStatus> status,
  Value<String?> replyToId,
  Value<int> rowid,
});

final class $$ChatTableTableReferences
    extends BaseReferences<_$LocalDatabase, $ChatTableTable, ChatEntity> {
  $$ChatTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatTableTable _replyToIdTable(_$LocalDatabase db) =>
      db.chatTable.createAlias(
          $_aliasNameGenerator(db.chatTable.replyToId, db.chatTable.id));

  $$ChatTableTableProcessedTableManager? get replyToId {
    final $_column = $_itemColumn<String>('reply_to_id');
    if ($_column == null) return null;
    final manager = $$ChatTableTableTableManager($_db, $_db.chatTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_replyToIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$InteractedUserTableTable,
      List<InteractedUserEntity>> _interactedUserTableRefsTable(
          _$LocalDatabase db) =>
      MultiTypedResultKey.fromTable(db.interactedUserTable,
          aliasName: $_aliasNameGenerator(
              db.chatTable.id, db.interactedUserTable.lastMessage));

  $$InteractedUserTableTableProcessedTableManager get interactedUserTableRefs {
    final manager = $$InteractedUserTableTableTableManager(
            $_db, $_db.interactedUserTable)
        .filter((f) => f.lastMessage.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_interactedUserTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChatTableTableFilterComposer
    extends Composer<_$LocalDatabase, $ChatTableTable> {
  $$ChatTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chatId => $composableBuilder(
      column: $table.chatId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get msg => $composableBuilder(
      column: $table.msg, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get read => $composableBuilder(
      column: $table.read, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<ChatType, ChatType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get toId => $composableBuilder(
      column: $table.toId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromId => $composableBuilder(
      column: $table.fromId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get readTime => $composableBuilder(
      column: $table.readTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sentTime => $composableBuilder(
      column: $table.sentTime, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<MediaModel>, List<MediaModel>, String>
      get medias => $composableBuilder(
          column: $table.medias,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<MessageStatus, MessageStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$ChatTableTableFilterComposer get replyToId {
    final $$ChatTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.replyToId,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableFilterComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> interactedUserTableRefs(
      Expression<bool> Function($$InteractedUserTableTableFilterComposer f) f) {
    final $$InteractedUserTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.interactedUserTable,
        getReferencedColumn: (t) => t.lastMessage,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InteractedUserTableTableFilterComposer(
              $db: $db,
              $table: $db.interactedUserTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $ChatTableTable> {
  $$ChatTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chatId => $composableBuilder(
      column: $table.chatId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get msg => $composableBuilder(
      column: $table.msg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get read => $composableBuilder(
      column: $table.read, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toId => $composableBuilder(
      column: $table.toId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromId => $composableBuilder(
      column: $table.fromId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get readTime => $composableBuilder(
      column: $table.readTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sentTime => $composableBuilder(
      column: $table.sentTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medias => $composableBuilder(
      column: $table.medias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  $$ChatTableTableOrderingComposer get replyToId {
    final $$ChatTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.replyToId,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableOrderingComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ChatTableTable> {
  $$ChatTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chatId =>
      $composableBuilder(column: $table.chatId, builder: (column) => column);

  GeneratedColumn<String> get msg =>
      $composableBuilder(column: $table.msg, builder: (column) => column);

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ChatType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get toId =>
      $composableBuilder(column: $table.toId, builder: (column) => column);

  GeneratedColumn<String> get fromId =>
      $composableBuilder(column: $table.fromId, builder: (column) => column);

  GeneratedColumn<DateTime> get readTime =>
      $composableBuilder(column: $table.readTime, builder: (column) => column);

  GeneratedColumn<DateTime> get sentTime =>
      $composableBuilder(column: $table.sentTime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<MediaModel>, String> get medias =>
      $composableBuilder(column: $table.medias, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$ChatTableTableAnnotationComposer get replyToId {
    final $$ChatTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.replyToId,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableAnnotationComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> interactedUserTableRefs<T extends Object>(
      Expression<T> Function($$InteractedUserTableTableAnnotationComposer a)
          f) {
    final $$InteractedUserTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.interactedUserTable,
            getReferencedColumn: (t) => t.lastMessage,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InteractedUserTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.interactedUserTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ChatTableTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $ChatTableTable,
    ChatEntity,
    $$ChatTableTableFilterComposer,
    $$ChatTableTableOrderingComposer,
    $$ChatTableTableAnnotationComposer,
    $$ChatTableTableCreateCompanionBuilder,
    $$ChatTableTableUpdateCompanionBuilder,
    (ChatEntity, $$ChatTableTableReferences),
    ChatEntity,
    PrefetchHooks Function({bool replyToId, bool interactedUserTableRefs})> {
  $$ChatTableTableTableManager(_$LocalDatabase db, $ChatTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chatId = const Value.absent(),
            Value<String> msg = const Value.absent(),
            Value<bool> read = const Value.absent(),
            Value<ChatType> type = const Value.absent(),
            Value<String> toId = const Value.absent(),
            Value<String> fromId = const Value.absent(),
            Value<DateTime?> readTime = const Value.absent(),
            Value<DateTime> sentTime = const Value.absent(),
            Value<List<MediaModel>> medias = const Value.absent(),
            Value<MessageStatus> status = const Value.absent(),
            Value<String?> replyToId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatTableCompanion(
            id: id,
            chatId: chatId,
            msg: msg,
            read: read,
            type: type,
            toId: toId,
            fromId: fromId,
            readTime: readTime,
            sentTime: sentTime,
            medias: medias,
            status: status,
            replyToId: replyToId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chatId,
            required String msg,
            required bool read,
            required ChatType type,
            required String toId,
            required String fromId,
            Value<DateTime?> readTime = const Value.absent(),
            required DateTime sentTime,
            required List<MediaModel> medias,
            required MessageStatus status,
            Value<String?> replyToId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatTableCompanion.insert(
            id: id,
            chatId: chatId,
            msg: msg,
            read: read,
            type: type,
            toId: toId,
            fromId: fromId,
            readTime: readTime,
            sentTime: sentTime,
            medias: medias,
            status: status,
            replyToId: replyToId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {replyToId = false, interactedUserTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (interactedUserTableRefs) db.interactedUserTable
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (replyToId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.replyToId,
                    referencedTable:
                        $$ChatTableTableReferences._replyToIdTable(db),
                    referencedColumn:
                        $$ChatTableTableReferences._replyToIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (interactedUserTableRefs)
                    await $_getPrefetchedData<ChatEntity, $ChatTableTable, InteractedUserEntity>(
                        currentTable: table,
                        referencedTable: $$ChatTableTableReferences
                            ._interactedUserTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatTableTableReferences(db, table, p0)
                                .interactedUserTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.lastMessage == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChatTableTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $ChatTableTable,
    ChatEntity,
    $$ChatTableTableFilterComposer,
    $$ChatTableTableOrderingComposer,
    $$ChatTableTableAnnotationComposer,
    $$ChatTableTableCreateCompanionBuilder,
    $$ChatTableTableUpdateCompanionBuilder,
    (ChatEntity, $$ChatTableTableReferences),
    ChatEntity,
    PrefetchHooks Function({bool replyToId, bool interactedUserTableRefs})>;
typedef $$InteractedUserTableTableCreateCompanionBuilder
    = InteractedUserTableCompanion Function({
  required String userId,
  required DateTime lastInteractedAt,
  required String chatId,
  Value<String?> lastMessage,
  Value<int> rowid,
});
typedef $$InteractedUserTableTableUpdateCompanionBuilder
    = InteractedUserTableCompanion Function({
  Value<String> userId,
  Value<DateTime> lastInteractedAt,
  Value<String> chatId,
  Value<String?> lastMessage,
  Value<int> rowid,
});

final class $$InteractedUserTableTableReferences extends BaseReferences<
    _$LocalDatabase, $InteractedUserTableTable, InteractedUserEntity> {
  $$InteractedUserTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UserTableTable _userIdTable(_$LocalDatabase db) =>
      db.userTable.createAlias(
          $_aliasNameGenerator(db.interactedUserTable.userId, db.userTable.id));

  $$UserTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserTableTableTableManager($_db, $_db.userTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ChatTableTable _lastMessageTable(_$LocalDatabase db) =>
      db.chatTable.createAlias($_aliasNameGenerator(
          db.interactedUserTable.lastMessage, db.chatTable.id));

  $$ChatTableTableProcessedTableManager? get lastMessage {
    final $_column = $_itemColumn<String>('last_message');
    if ($_column == null) return null;
    final manager = $$ChatTableTableTableManager($_db, $_db.chatTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lastMessageTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InteractedUserTableTableFilterComposer
    extends Composer<_$LocalDatabase, $InteractedUserTableTable> {
  $$InteractedUserTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get lastInteractedAt => $composableBuilder(
      column: $table.lastInteractedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chatId => $composableBuilder(
      column: $table.chatId, builder: (column) => ColumnFilters(column));

  $$UserTableTableFilterComposer get userId {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserTableTableFilterComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChatTableTableFilterComposer get lastMessage {
    final $$ChatTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastMessage,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableFilterComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InteractedUserTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $InteractedUserTableTable> {
  $$InteractedUserTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get lastInteractedAt => $composableBuilder(
      column: $table.lastInteractedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chatId => $composableBuilder(
      column: $table.chatId, builder: (column) => ColumnOrderings(column));

  $$UserTableTableOrderingComposer get userId {
    final $$UserTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserTableTableOrderingComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChatTableTableOrderingComposer get lastMessage {
    final $$ChatTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastMessage,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableOrderingComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InteractedUserTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $InteractedUserTableTable> {
  $$InteractedUserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get lastInteractedAt => $composableBuilder(
      column: $table.lastInteractedAt, builder: (column) => column);

  GeneratedColumn<String> get chatId =>
      $composableBuilder(column: $table.chatId, builder: (column) => column);

  $$UserTableTableAnnotationComposer get userId {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserTableTableAnnotationComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChatTableTableAnnotationComposer get lastMessage {
    final $$ChatTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastMessage,
        referencedTable: $db.chatTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatTableTableAnnotationComposer(
              $db: $db,
              $table: $db.chatTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InteractedUserTableTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $InteractedUserTableTable,
    InteractedUserEntity,
    $$InteractedUserTableTableFilterComposer,
    $$InteractedUserTableTableOrderingComposer,
    $$InteractedUserTableTableAnnotationComposer,
    $$InteractedUserTableTableCreateCompanionBuilder,
    $$InteractedUserTableTableUpdateCompanionBuilder,
    (InteractedUserEntity, $$InteractedUserTableTableReferences),
    InteractedUserEntity,
    PrefetchHooks Function({bool userId, bool lastMessage})> {
  $$InteractedUserTableTableTableManager(
      _$LocalDatabase db, $InteractedUserTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InteractedUserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InteractedUserTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InteractedUserTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<DateTime> lastInteractedAt = const Value.absent(),
            Value<String> chatId = const Value.absent(),
            Value<String?> lastMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InteractedUserTableCompanion(
            userId: userId,
            lastInteractedAt: lastInteractedAt,
            chatId: chatId,
            lastMessage: lastMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required DateTime lastInteractedAt,
            required String chatId,
            Value<String?> lastMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InteractedUserTableCompanion.insert(
            userId: userId,
            lastInteractedAt: lastInteractedAt,
            chatId: chatId,
            lastMessage: lastMessage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InteractedUserTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, lastMessage = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$InteractedUserTableTableReferences._userIdTable(db),
                    referencedColumn: $$InteractedUserTableTableReferences
                        ._userIdTable(db)
                        .id,
                  ) as T;
                }
                if (lastMessage) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lastMessage,
                    referencedTable: $$InteractedUserTableTableReferences
                        ._lastMessageTable(db),
                    referencedColumn: $$InteractedUserTableTableReferences
                        ._lastMessageTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InteractedUserTableTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $InteractedUserTableTable,
    InteractedUserEntity,
    $$InteractedUserTableTableFilterComposer,
    $$InteractedUserTableTableOrderingComposer,
    $$InteractedUserTableTableAnnotationComposer,
    $$InteractedUserTableTableCreateCompanionBuilder,
    $$InteractedUserTableTableUpdateCompanionBuilder,
    (InteractedUserEntity, $$InteractedUserTableTableReferences),
    InteractedUserEntity,
    PrefetchHooks Function({bool userId, bool lastMessage})>;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$ChatTableTableTableManager get chatTable =>
      $$ChatTableTableTableManager(_db, _db.chatTable);
  $$InteractedUserTableTableTableManager get interactedUserTable =>
      $$InteractedUserTableTableTableManager(_db, _db.interactedUserTable);
}
