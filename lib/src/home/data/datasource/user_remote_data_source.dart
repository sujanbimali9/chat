import 'dart:developer';
import 'dart:io';
import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/services/api_service.dart';
import 'dart:async';

abstract interface class UserRemoteDataSource {
  Future<ApiResponse<UserModel, UserPagination>> getAllUsers({
    required int limit,
    required int offset,
  });
  Future<ApiResponse<({UserModel user, ChatModel chat}), UserPagination>>
  getConversationHistory({required int limit, required int offset});
  Future<UserModel> getUserById(String id);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUser(UserModel user);
  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  });
  Future<UserModel> updateProfileImage(File file);
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final ApiService _apiService;

  UserRemoteDataSourceImp(this._apiService);

  Future<T> _handleException<T>(
    Future<T> Function() operation, {
    String context = '',
  }) async {
    try {
      return await operation();
    } on SocketException catch (e) {
      log(
        'Socket Error: ${e.message}',
        name: 'UserRemoteDataSourceImp.$context',
      );
      throw ServerException(e.message);
    } on ServerException catch (e) {
      log(
        'Server Error: ${e.message}',
        name: 'UserRemoteDataSourceImp.$context',
      );
      rethrow;
    } catch (e) {
      log('Unexpected Error: $e', name: 'UserRemoteDataSourceImp.$context');
      rethrow;
    }
  }

  @override
  Future<ApiResponse<UserModel, UserPagination>> getAllUsers({
    required int limit,
    required int offset,
  }) {
    return _handleException(() async {
      final users = await _apiService.get(
        'users',
        query: {'limit': limit, 'offset': offset},
      );
      return ApiResponse.fromJson(
        users,
        UserModel.fromJson,
        UserPagination.fromJson,
      );
    }, context: 'getAllUser');
  }

  @override
  Future<UserModel> getCurrentUser() {
    return _handleException(() async {
      final user = await _apiService.get('users/me');
      return UserModel.fromJson(user['data']);
    }, context: 'getCurrentUser');
  }

  @override
  Future<UserModel> getUserById(String id) {
    return _handleException(() async {
      final user = await _apiService.get('users/$id');
      return UserModel.fromJson(user['data']);
    }, context: 'getUserById');
  }

  @override
  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) {
    return _handleException(() async {
      final users = await _apiService.get(
        'users/search',
        query: {'query': query},
      );
      return ApiResponse.fromJson(
        users,
        UserModel.fromJson,
        UserPagination.fromJson,
      );
    }, context: 'searchUser');
  }

  @override
  Future<UserModel> updateProfileImage(File file) {
    return _handleException(() async {
      final url = await _apiService.upload(
        file.path,
        storagePath: 'users/profile-image',
        url: 'upload',
      );
      final user = await _apiService.put(
        'users/me',
        data: {'profileImage': url},
      );
      return UserModel.fromJson(user['data']);
    }, context: 'updateProfileImage');
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<({UserModel user, ChatModel chat}), UserPagination>>
  getConversationHistory({required int limit, required int offset}) {
    return _handleException(() async {
      final users = await _apiService.get(
        'users/interacted',
        query: {'limit': limit, 'offset': offset},
      );
      return ApiResponse.fromJson(
        users,
        (user) {
          return (
            user: UserModel.fromJson(user['user']),
            chat: ChatModel.fromJson(user['chat']),
          );
        },
        UserPagination.fromJson,
        dataSource: ApiDataSource.remote,
      );
    }, context: 'getInteractedUser');
  }
}
