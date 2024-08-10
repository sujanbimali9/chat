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
  factory UserModel.fromSupabaseUser(Map<String, dynamic> json) {
    return UserModel(
      about: json['about'] ?? '',
      id: json['id'],
      fullName: json['user_metadata']['name'],
      email: json['email'],
      profileImage: json['user_metadata']['avatar_url'] ??
          json['user_metadata']['picture'] ??
          '',
      blocked: const [],
      createdAt: json['created_at'],
      dateofBirth: '',
      friends: const [],
      isOnline: true,
      lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
      showOnlineStatus: true,
      phone: json['phone'],
      pushToken: '',
      username: json['user_metadata']['name'],
    );
  }
  Map<String, dynamic> toJson() {
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

  @override
  UserModel copyWith({
    String? about,
    String? id,
    String? fullName,
    String? email,
    String? profileImage,
    List<String>? blocked,
    String? createdAt,
    String? dateofBirth,
    List<String>? friends,
    bool? isOnline,
    String? lastActive,
    bool? showOnlineStatus,
    String? phone,
    String? pushToken,
    String? username,
  }) {
    return UserModel(
      about: about ?? super.about,
      id: id ?? super.id,
      fullName: fullName ?? super.fullName,
      email: email ?? super.email,
      profileImage: profileImage ?? super.profileImage,
      blocked: blocked ?? super.blocked,
      createdAt: createdAt ?? super.createdAt,
      dateofBirth: dateofBirth ?? super.dateofBirth,
      friends: friends ?? super.friends,
      isOnline: isOnline ?? super.isOnline,
      lastActive: lastActive ?? super.lastActive,
      showOnlineStatus: showOnlineStatus ?? super.showOnlineStatus,
      phone: phone ?? super.phone,
      pushToken: pushToken ?? super.pushToken,
      username: username ?? super.username,
    );
  }
}
