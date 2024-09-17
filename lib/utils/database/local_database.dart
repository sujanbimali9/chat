import 'dart:developer';
import 'dart:io';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/generator/id_generator.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._();
  static bool _isInitialized = false;
  static final LocalDatabase _instance = LocalDatabase._();
  static LocalDatabase get instance => _instance;
  static late final Database _db;
  static Future<void> initializeLocalDatabase({String? databaseName}) async {
    assert(!_isInitialized, 'LocalDatabase is already initialized');
    if (!_isInitialized) {
      final path = await getDatabasesPath();

      _db = await openDatabase(
        '$path${databaseName ?? 'chat_app'}.db',
        version: 1,
        onCreate: (Database db, int version) async {
          const createUserTable = '''
            CREATE TABLE IF NOT EXISTS users (
                    about TEXT,
                    id TEXT PRIMARY KEY,
                    full_name TEXT NOT NULL,
                    email TEXT,
                    profile_image TEXT NULL,
                    created_at TEXT NOT NULL,
                    date_of_birth TEXT,
                    last_active TEXT,
                    show_online_status INT  DEFAULT 1,
                    phone TEXT,
                    push_token TEXT ,
                    user_name TEXT)''';

          const createMetaDataTable = '''
            CREATE TABLE metadata (
                    id TEXT PRIMARY KEY, 
                    aspect_ratio REAL,
                    duration INT,
                    height INT,
                    thumbnail TEXT,
                    title TEXT,
                    width INT)''';
          const createChatTable = '''
          CREATE TABLE chats (
                    id TEXT PRIMARY KEY,
                    chat_id TEXT NOT NULL,
                    msg TEXT NOT NULL,
                    to_id TEXT NOT NULL,
                    read INT NOT NULL,
                    type TEXT NOT NULL,
                    from_id TEXT NOT NULL,
                    read_time BIGINT,
                    sent_time BIGINT NOT NULL,
                    status TEXT CHECK (status IN ('sending', 'sent', 'failed', 'seen')),
                    FOREIGN KEY (to_id) REFERENCES users(id),
                    FOREIGN KEY (from_id) REFERENCES users(id),
                    FOREIGN KEY (id) REFERENCES metadata(id))''';
          const createLastChatTable = '''
            CREATE TABLE last_chats (
                    id TEXT NOT NULL,
                    chat_id TEXT PRIMARY KEY,
                    msg TEXT NOT NULL,
                    to_id TEXT NOT NULL,
                    read INT NOT NULL,
                    type TEXT NOT NULL,
                    from_id TEXT NOT NULL,
                    read_time BIGINT,
                    sent_time BIGINT NOT NULL,                    
                    status TEXT CHECK (status IN ('sending', 'sent', 'failed', 'seen')),
                    FOREIGN KEY (to_id) REFERENCES users(id),
                    FOREIGN KEY (from_id) REFERENCES users(id),
                    FOREIGN KEY (id) REFERENCES metadata(id))''';

          await db.execute(createUserTable);
          await db.execute(createMetaDataTable);
          await db.execute(createChatTable);
          await db.execute(createLastChatTable);
        },
      );
      _isInitialized = true;
    }
  }

  Future<void> insertUser(UserModel user) async {
    log('insertUser $user');
    await _db.insert('users', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertChat(ChatModel chat) async {
    log('insertChat $chat');
    final data = chat.toJson();
    await _db.transaction(
      (txn) async {
        if (data['metadata'] != null) {
          data['metadata']['id'] = data['id'];
          await txn.insert(
            'metadata',
            data['metadata'],
          );
        }
        data.remove('metadata');

        await txn.insert('chats', data,
            conflictAlgorithm: ConflictAlgorithm.replace);
      },
    );
  }

  Future<void> insertLastChat(ChatModel chat) async {
    log('insertLastChat $chat');
    final data = chat.toJson();
    await _db.transaction(
      (txn) async {
        if (data['metadata'] != null) {
          data['metadata']['id'] = data['id'];

          await txn.insert(
            'metadata',
            data['metadata'],
          );
        }
        data.remove('metadata');

        await txn.insert('last_chats', data,
            conflictAlgorithm: ConflictAlgorithm.replace);
      },
    );
  }

  Future<void> insertUsers(List<UserModel> users) async {
    log('insertUsers $users');
    final batch = _db.batch();
    for (final user in users) {
      batch.insert('users', user.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertChats(List<ChatModel> chats) async {
    log('insertChats $chats');
    final batch = _db.batch();
    for (final chat in chats) {
      final data = chat.toJson();
      if (data['metadata'] != null) {
        data['metadata']['id'] = data['id'];

        batch.insert(
          'metadata',
          data['metadata'],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      data.remove('metadata');

      batch.insert(
        'chats',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertLastChats(List<ChatModel> chats) async {
    log('insertLastChats $chats');
    final batch = _db.batch();
    for (final chat in chats) {
      final data = chat.toJson();
      if (data['metadata'] != null) {
        data['metadata']['id'] = data['id'];

        batch.insert(
          'metadata',
          data['metadata'],
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      data.remove('metadata');
      batch.insert(
        'last_chats',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<Map<String, UserModel>> getUsers(String currentUserId,
      {int? limit, int? offset}) async {
    log('getUsers $currentUserId');
    final List<Map<String, dynamic>> users = await _db.query('users',
        where: 'id != ?',
        whereArgs: [currentUserId],
        limit: limit,
        offset: 0,
        orderBy: 'last_active DESC');
    return {
      for (var i = 0; i < users.length; i++)
        users[i]['id']!: UserModel.fromJson(users[i])
    };
  }

  Future<Map<int, ChatModel>> getChats(String chatId,
      {int? limit, int? offset}) async {
    log('getChats $chatId');
    final List<Map<String, dynamic>> results = await _db.rawQuery(
      '''
      SELECT chats.*, metadata.aspect_ratio, metadata.duration, metadata.height, metadata.thumbnail, metadata.title, metadata.width
      FROM chats
      LEFT JOIN metadata ON chats.id = metadata.id
      WHERE chats.chat_id = ?
      ORDER BY chats.sent_time DESC
      LIMIT ?
      OFFSET ?
    ''',
      [chatId, limit ?? -1, offset ?? 0],
    );
    log('getChats $results');

    final Map<int, ChatModel> chatsMap = {};
    for (final result in results) {
      final metadata = {
        'aspect_ratio': result['aspect_ratio'],
        'duration': result['duration'],
        'height': result['height'],
        'thumbnail': result['thumbnail'],
        'title': result['title'],
        'width': result['width'],
      };
      final chatData = {...result, 'metadata': metadata};

      final chat = ChatModel.fromJson(chatData);
      chatsMap[chat.sentTime] = chat;
    }
    return chatsMap;
  }

  Future<Map<String, ChatModel>> getLastChats(String userId,
      {int? limit, int? offset}) async {
    log('getLastChats $userId');
    final List<Map<String, dynamic>> chats = await _db.query(
      'last_chats',
      limit: limit,
      offset: offset,
      orderBy: 'sent_time DESC',
      where: 'to_id = ? OR from_id = ?',
      whereArgs: [userId, userId],
    );
    return {
      for (var i = 0; i < chats.length; i++)
        IdGenerator.getConversionId(chats[i]['from_id'], chats[i]['to_id']!):
            ChatModel.fromJson(chats[i])
    };
  }

  Future<void> deleteChat(String chatId) async {
    log('deleteChat $chatId');
    await _db.delete('chats', where: 'id = ?', whereArgs: [chatId]);
  }

  Future<void> deleteLastChat(String chatId) async {
    log('deleteLastChat $chatId');
    await _db.delete('last_chats', where: 'id = ?', whereArgs: [chatId]);
  }

  Future<void> deleteUser(String userId) async {
    log('deleteUser $userId');
    await _db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  Future<void> deleteAllUsers() async {
    log('deleteAllUsers');
    await _db.delete('users');
  }

  Future<void> deleteAllChats() async {
    log('deleteAllChats');
    await _db.delete('chats');
  }

  Future<void> deleteAllLastChats() async {
    log('deleteAllLastChats');
    await _db.delete('last_chats');
  }

  Future<void> deleteAll() async {
    log('deleteAll');
    await _db.delete('users');
    await _db.delete('chats');
    await _db.delete('last_chats');
  }

  Future<void> close() async {
    log('close');
    await _db.close();
  }

  Future<void> deleteDatabase() async {
    log('deleteDatabase');

    await _db.close();
    final path = await getDatabasesPath();
    final file = File('$path/chat_app.db');
    await file.delete();
  }

  Future<void> updateChat({ChatModel? chat, Map<String, dynamic>? data}) async {
    log('updateChat $chat $data');
    assert(chat != null || data != null);

    final chatData = data ?? chat!.toJson();
    await _db.update('chats', chatData,
        where: 'id = ?', whereArgs: [chatData['id']]);
  }

  Future<void> updateRead(String chatId) async {
    log('updateRead $chatId');
    await _db.update('chats', {'read': 1},
        where: 'chat_id = ?', whereArgs: [chatId]);
  }

  Future<UserModel> getUserById(String id) async {
    log('getUserById $id');
    final List<Map<String, dynamic>> users =
        await _db.query('users', where: 'id = ?', whereArgs: [id]);
    return users.map((e) => UserModel.fromJson(e)).first;
  }

  Future<Map<String, UserModel>> searchUser(String query) async {
    log('searchUser $query');
    final List<Map<String, dynamic>> users = await _db.query('users',
        where: 'full_name LIKE ? OR user_name LIKE ?',
        whereArgs: ['%$query%', '%$query%']);
    return {
      for (var i = 0; i < users.length; i++)
        users[i]['id']!: UserModel.fromJson(users[i])
    };
  }

  Future<void> insertPendingChat(ChatModel chat) async {
    log('insertPendingChat $chat');
    final data = chat.copyWith(status: MessageStatus.failed).toJson();
    await _db.transaction(
      (txn) async {
        if (data['metadata'] != null) {
          data['metadata']['id'] = data['id'];

          await txn.insert(
            'metadata',
            data['metadata'],
          );
        }
        data.remove('metadata');
        await txn.insert('chats', data,
            conflictAlgorithm: ConflictAlgorithm.replace);
      },
    );
  }

  Future<List<ChatModel>> getPendingChats() async {
    log('getPendingChats');
    final List<Map<String, dynamic>> chats = await _db.rawQuery(
      '''
      SELECT chats.*, metadata.aspect_ratio, metadata.duration, metadata.height, metadata.thumbnail, metadata.title, metadata.width
      FROM chats
      LEFT JOIN metadata ON chats.id = metadata.id
      WHERE status = 'sending' OR status = 'failed'
      ORDER BY sent_time DESC
    ''',
    );

    final result = <ChatModel>[];
    for (final chat in chats) {
      Map<String, dynamic>? metadata;
      if (chat['type'] != 'text') {
        metadata = {
          'aspect_ratio': chat['aspect_ratio'],
          'duration': chat['duration'],
          'height': chat['height'],
          'thumbnail': chat['thumbnail'],
          'title': chat['title'],
          'width': chat['width'],
        };
      }
      final chatData = {...chat, 'metadata': metadata};
      result.add(ChatModel.fromJson(chatData));
    }

    return result;
  }

  Future<void> updateUser(
      {UserModel? user, Map<String, dynamic>? userJson}) async {
    log('updateUser $user $userJson');
    assert(user != null || userJson != null);
    final data = userJson ?? user!.toJson();
    await _db.update('users', data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> upateRead(Map<String, dynamic> chatData) async {
    log('upateRead $chatData');
    await _db.update('chats', chatData,
        where: 'chat_id = ?', whereArgs: [chatData['chat_id']]);
  }
}
