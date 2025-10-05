import 'dart:io';
import 'dart:async';
import 'package:chat/core/common/model/api_response.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/core/mixins/exception_handler_mixin.dart';
import 'package:chat/src/home/data/model/conversation_model.dart';
import 'package:chat/src/home/data/model/user_model.dart';
import 'package:chat/utils/services/api_service.dart';

abstract interface class UserRemoteDataSource {
  Future<ApiResponse<UserModel, UserPagination>> getAllUsers({
    required int limit,
    required int offset,
  });
  Future<ApiResponse<ConversationModel, UserPagination>>
  getConversationHistory({required int limit, required int offset});
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUser(UserModel user);
  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  });
  Future<UserModel> updateProfileImage(File file);
}

class UserRemoteDataSourceImp
    with NetworkExceptionHandlerMixin
    implements UserRemoteDataSource {
  final ApiService _apiService;

  UserRemoteDataSourceImp(this._apiService);

  @override
  Future<ApiResponse<UserModel, UserPagination>> getAllUsers({
    required int limit,
    required int offset,
  }) {
    return handleNetworkException(() async {
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
    return handleNetworkException(() async {
      final user = await _apiService.get('users/me');
      return UserModel.fromJson(user['data']);
    }, context: 'getCurrentUser');
  }

  @override
  Future<ApiResponse<UserModel, UserPagination>> searchUser(
    String query, {
    required int limit,
    required int offset,
  }) {
    return handleNetworkException(() async {
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
    return handleNetworkException(() async {
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
  Future<ApiResponse<ConversationModel, UserPagination>>
  getConversationHistory({required int limit, required int offset}) {
    return handleNetworkException(() async {
      final res = await _apiService.get(
        'conversations',
        query: {'limit': limit, 'offset': offset},
      );

      return ApiResponse.fromJson(
        res,
        ConversationModel.fromJson,
        UserPagination.fromJson,
        dataSource: ApiDataSource.remote,
      );
    }, context: 'getConversationHistory');
  }
}
