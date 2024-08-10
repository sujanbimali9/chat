import 'dart:io';

import 'package:chat/src/home/data/model/user_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<Map<String, UserModel>> getAllUser({int? limit, int? offset});
  Future<UserModel> getUserById(String id);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<UserModel> createUser(UserModel user);
  Future<Map<String, UserModel>> searchUser(String query);
  // Future<void> sendFriendRequest(int id);
  // Future<void> acceptFriendRequest(int id);
  // Future<void> rejectFriendRequest(int id);
  // Future<void> cancelFriendRequest(int id);
  // Future<void> removeFriend(int id);
  // Future<void> blockUser(int id);
  // Future<void> unblockUser(int id);
  // Future<List<UserModel>> getFriends();
  // Future<List<UserModel>> getBlockedUsers();
  // Future<List<UserModel>> getFriendRequests();
  // Future<List<UserModel>> getPendingRequests();
  // Future<List<UserModel>> getSentRequests();
  Future<void> updateProfileImage(File file);
  Future<void> updateShowOnlineStatus(bool show);
}
