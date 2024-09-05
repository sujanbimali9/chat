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
    required super.userName,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      about: json['about'],
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      profileImage: json['profile_image'],
      blocked: List<String>.from(json['blocked']),
      createdAt: json['created_at'],
      dateofBirth: json['date_of_birth'],
      friends: List<String>.from(json['friends']),
      isOnline: json['is_online'],
      lastActive: json['last_active'],
      showOnlineStatus: json['show_online_status'],
      phone: json['phone'],
      pushToken: json['push_token'],
      userName: json['user_name'],
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
        userName: user.userName);
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
      userName: json['user_metadata']['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'about': super.about,
      'id': super.id,
      'full_name': super.fullName,
      'email': super.email,
      'profile_image': super.profileImage,
      'blocked': super.blocked,
      'created_at': super.createdAt,
      'date_of_birth': super.dateofBirth,
      'friends': super.friends,
      'is_online': super.isOnline,
      'last_active': super.lastActive,
      'show_online_status': super.showOnlineStatus,
      'phone': super.phone,
      'push_token': super.pushToken,
      'user_name': super.userName,
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
    String? userName,
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
      userName: userName ?? super.userName,
    );
  }
}
