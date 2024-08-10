import 'package:chat/core/common/model/user.dart';

class UserModel extends User {
  const UserModel({
    required super.about,
    required super.id,
    required super.fullName,
    required super.email,
    required super.profileImage,
    required super.blocked,
    required super.createdAt,
    required super.dateofBirth,
    required super.friends,
    required super.isOnline,
    required super.lastActive,
    required super.showOnlineStatus,
    required super.phone,
    required super.pushToken,
    required super.username,
  });
  factory UserModel.fromJson(Map json) {
    return UserModel(
      about: json['about'],
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      profileImage: json['profileImage'],
      blocked: json['blocked'],
      createdAt: json['createdAt'],
      dateofBirth: json['dateofBirth'],
      friends: json['friends'],
      isOnline: json['isOnline'],
      lastActive: json['lastActive'],
      showOnlineStatus: json['showOnlineStatus'],
      phone: json['phone'],
      pushToken: json['pushToken'],
      username: json['username'],
    );
  }
  factory UserModel.fromUser(User user) {
    return UserModel(
        about: user.about,
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        profileImage: user.profileImage,
        blocked: user.blocked,
        createdAt: user.createdAt,
        dateofBirth: user.dateofBirth,
        friends: user.friends,
        isOnline: user.isOnline,
        lastActive: user.lastActive,
        showOnlineStatus: user.showOnlineStatus,
        phone: user.phone,
        pushToken: user.pushToken,
        username: user.username);
  }
  toJson() {
    return {
      'about': super.about,
      'id': super.id,
      'fullName': super.fullName,
      'email': super.email,
      'profileImage': super.profileImage,
      'blocked': super.blocked,
      'createdAt': super.createdAt,
      'dateofBirth': super.dateofBirth,
      'friends': super.friends,
      'isOnline': super.isOnline,
      'lastActive': super.lastActive,
      'showOnlineStatus': super.showOnlineStatus,
      'phone': super.phone,
      'pushToken': super.pushToken,
      'username': super.username,
    };
  }
}
