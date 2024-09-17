import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeLocalDataSource {
  Future<Map<String, UserModel>> getAllUser({int? limit, int? offset});
  Future<UserModel> getUserById(String id);
  Future<UserModel> updateUser(Map<String, dynamic> user);
  Future<UserModel> createUser(UserModel user);
  Future<Map<String, UserModel>> searchUser(String query);
  Future<Map<String, ChatModel>> getLastChat();
  Future<void> saveCurrentUser(UserModel res);
  Future<void> savelastChats(List<ChatModel> chat);
  Future<void> deleteUser(String id);
  Future<UserModel> getCurrentUser();
  Future<void> saveUsers(List<UserModel> list);
}

class HomeLocalDataSourceImp extends HomeLocalDataSource {
  final LocalDatabase _localDatabase;
  final SupabaseClient _client;

  HomeLocalDataSourceImp(LocalDatabase localDatabase, SupabaseClient client)
      : _localDatabase = localDatabase,
        _client = client;
  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      await _localDatabase.insertUser(user);
      return user;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, UserModel>> getAllUser({int? limit, int? offset}) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final users =
          await _localDatabase.getUsers(userId, limit: limit, offset: offset);
      return users;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, ChatModel>> getLastChat() async {
    try {
      final userId = _client.auth.currentUser!.id;
      final chats = await _localDatabase.getLastChats(userId);
      return chats;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final user = await _localDatabase.getUserById(id);
      return user;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, UserModel>> searchUser(String query) async {
    try {
      final users = await _localDatabase.searchUser(query);
      return users;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(Map<String, dynamic> user) async {
    try {
      await _localDatabase.updateUser(userJson: user);
      final updatedUser = await _localDatabase.getUserById(user['id']);
      return updatedUser;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _localDatabase.deleteUser(id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final userId = _client.auth.currentUser!.id;
      final user = await _localDatabase.getUserById(userId);
      return user;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> saveCurrentUser(UserModel res) async {
    try {
      await _localDatabase.insertUser(res);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> savelastChats(List<ChatModel> chat) async {
    try {
      await _localDatabase.insertLastChats(chat);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> saveUsers(List<UserModel> list) async {
    try {
      await _localDatabase.insertUsers(list);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
