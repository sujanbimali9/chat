import 'dart:developer';
import 'dart:io';

import 'package:chat/core/exception/server_exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<Map<String, UserModel>> getAllUser({int? limit, int? offset});
  Future<UserModel> getUserById(String id);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<UserModel> createUser();
  Future<Map<String, UserModel>> searchUser(String query);
  Future<Map<String, ChatModel>> getLastChat();
  Future<UserModel> updateProfileImage(File file);
  Future<void> updateOnlineStatus(bool show);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient _client;

  HomeRemoteDataSourceImpl(SupabaseClient client) : _client = client;
  @override
  Future<UserModel> createUser() async {
    try {
      final previousUser = await _client
          .from('users')
          .select()
          .eq('id', _client.auth.currentUser!.id)
          .limit(1);
      if (previousUser.isNotEmpty) {
        return UserModel.fromJson(previousUser.first);
      }
      final user =
          UserModel.fromSupabaseUser(_client.auth.currentUser!.toJson());
      final response =
          await _client.from('users').insert(user).select().single();
      return UserModel.fromJson(response);
    } on SocketException catch (e) {
      log('CreateUser error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('CreateUser error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('CreateUser error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, UserModel>> getAllUser({int? limit, int? offset}) async {
    try {
      final res = _client
          .from('users')
          .select()
          .neq('id', _client.auth.currentUser!.id);
      if (limit != null) {
        res.limit(limit);
      }
      if (offset != null) {
        res.range(offset, limit! + offset);
      }

      final resonse = await res;
      final result = <String, UserModel>{};

      for (var e in resonse) {
        result[e['id']] = UserModel.fromJson(e);
      }
      return result;
    } on SocketException catch (e) {
      log('GetAllUser error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('GetAllUser error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('GetAllUser error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final res = _client
          .from('users')
          .select()
          .eq('id', _client.auth.currentUser!.id)
          .single();
      final resonse = await res;
      return UserModel.fromJson(resonse);
    } on SocketException catch (e) {
      log('GetCurrentUser error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('GetCurrentUser error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('GetCurrentUser error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final res = _client.from('users').select().neq('id', id).single();
      final resonse = await res;
      return UserModel.fromJson(resonse);
    } on SocketException catch (e) {
      log('GetUserById error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('GetUserById error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('GetUserById error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, UserModel>> searchUser(String query) async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateProfileImage(File file) async {
    try {
      final path = 'profile/${_client.auth.currentUser!.id}.jpg';
      final userId = _client.auth.currentUser!.id;
      await _client.storage.from('users').upload(path, file);
      final url = _client.storage.from('users').getPublicUrl(path);
      final user = await _client
          .from('users')
          .update({'avatar_url': url})
          .eq('id', userId)
          .select()
          .single();
      return UserModel.fromJson(user);
    } on SocketException catch (e) {
      log('UpdateProfileImage error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('UpdateProfileImage error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('UpdateProfileImage error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateOnlineStatus(bool show) async {
    try {
      final pushToken = await FirebaseMessaging.instance.getToken();
      await _client.from('users').update({
        'is_online': show,
        'push_token': pushToken,
        'last_active': DateTime.now().millisecondsSinceEpoch,
      }).eq('id', _client.auth.currentUser!.id);
    } on SocketException catch (e) {
      log('UpdateShowOnlineStatus error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('UpdateShowOnlineStatus error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('UpdateShowOnlineStatus error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await _client
          .from('users')
          .update(user.toJson())
          .eq('id', _client.auth.currentUser!.id)
          .select()
          .single();
      return UserModel.fromJson(response);
    } on SocketException catch (e) {
      log('UpdateUser error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('UpdateUser error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('UpdateUser error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, ChatModel>> getLastChat() async {
    final currentUserId = _client.auth.currentUser!.id;

    try {
      //   return _client
      //       .from('chats')
      //       .stream(primaryKey: ['chat_id'])
      //       .inFilter('chat_id', chatids)
      //       .map((e) {
      //         return {
      //           for (var i in e) i['chat_id'] as String: ChatModel.fromJson(i)
      //         };
      //       });
      final res = await _client
          .from('chats')
          .select()
          .or('from_id.eq.$currentUserId,to_id.eq.$currentUserId');

      return {for (var i in res) i['chat_id'] as String: ChatModel.fromJson(i)};
    } on SocketException catch (e) {
      log('GetLastChat error: SocketException $e');
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      log('GetLastChat error: PostgrestException $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('GetLastChat error: $e');
      throw ServerException(message: e.toString());
    }
  }
}
