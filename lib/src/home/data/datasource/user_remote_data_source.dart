import 'dart:developer';
import 'dart:io';
import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/services/api_service.dart';
import 'dart:async';

import 'package:chat/utils/services/socket_io.dart';

abstract interface class UserRemoteDataSource {
  Future<ApiResponse<UserModel>> getAllUsers(
      {required int limit, required int offset});
  Future<ApiResponse<UserModel>> getInteractedUser(
      {required int limit, required int offset});
  Future<UserModel> getUserById(String id);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUser(UserModel user);
  Future<ApiResponse<UserModel>> searchUser(
    String query, {
    required int limit,
    required int offset,
  });
  Future<UserModel> updateProfileImage(File file);
  Stream<UserModel> getUserStream();
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final ApiService _apiService;
  final SocketIOService _socketIO;

  UserRemoteDataSourceImp(this._apiService, this._socketIO);

  Future<T> _handleException<T>(Future<T> Function() operation,
      {String? context}) async {
    try {
      return await operation();
    } on SocketException catch (e) {
      log('${context ?? 'UserRemoteDataSourceImp'} socket Error: $e');
      throw ServerException(e.message);
    } catch (e) {
      log('${context ?? 'UserRemoteDataSourceImp'} error: $e');
      rethrow;
    }
  }

  @override
  Future<ApiResponse<UserModel>> getAllUsers(
      {required int limit, required int offset}) {
    return _handleException(() async {
      final users = await _apiService.get(
        'users',
        query: {
          'limit': limit,
          'offset': offset,
        },
      );
      return ApiResponse.fromJson(users, UserModel.fromJson);
    }, context: 'UserRemoteDataSourceImp.getAllUser');
  }

  @override
  Future<UserModel> getCurrentUser() {
    return _handleException(() async {
      final user = await _apiService.get('users/me');
      return UserModel.fromJson(user['data']);
    }, context: 'UserRemoteDataSourceImp.getCurrentUser');
  }

  @override
  Future<UserModel> getUserById(String id) {
    return _handleException(() async {
      final user = await _apiService.get('users/$id');
      return UserModel.fromJson(user['data']);
    }, context: 'UserRemoteDataSourceImp.getUserById');
  }

  @override
  Stream<UserModel> getUserStream() {
    try {
      final stream = _socketIO.userStream;
      return stream.map(UserModel.fromJson);
    } catch (e) {
      log('SyncUsers error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ApiResponse<UserModel>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) {
    return _handleException(() async {
      final users = await _apiService.get(
        'users/search',
        query: {'query': query},
      );
      return ApiResponse.fromJson(users, UserModel.fromJson);
    }, context: 'UserRemoteDataSourceImp.searchUser');
  }

  @override
  Future<UserModel> updateProfileImage(File file) {
    return _handleException(() async {
      final url = await _apiService.upload(file.path,
          storagePath: 'users/profile-image', url: 'upload');
      final user = await _apiService.put('users/me', data: {
        'profileImage': url,
      });
      return UserModel.fromJson(user['data']);
    }, context: 'UserRemoteDataSourceImp.updateProfileImage');
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<UserModel>> getInteractedUser(
      {required int limit, required int offset}) {
    return _handleException(() async {
      final users = await _apiService.get(
        'users/interacted',
        query: {
          'limit': limit,
          'offset': offset,
        },
      );
      return ApiResponse.fromJson(
        users,
        UserModel.fromJson,
        dataSource: ApiDataSource.remote,
      );
    }, context: 'UserRemoteDataSourceImp.getInteractedUser');
  }
}
