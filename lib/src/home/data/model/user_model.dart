import 'package:chat/core/common/model/user.dart';

class UserModel extends User {
  const UserModel({
    required super.about,
    required super.id,
    required super.fullName,
    required super.email,
    required super.profileImage,
    required super.createdAt,
    required super.dateofBirth,
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
      createdAt: json['created_at'],
      dateofBirth: json['date_of_birth'],
      lastActive: json['last_active'],
      showOnlineStatus: _getBool(json['show_online_status']),
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
        createdAt: user.createdAt,
        dateofBirth: user.dateofBirth,
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
      createdAt: json['created_at'],
      dateofBirth: '',
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
      'created_at': super.createdAt,
      'date_of_birth': super.dateofBirth,
      'last_active': super.lastActive,
      'show_online_status': super.showOnlineStatus ? 1 : 0,
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
    String? createdAt,
    String? dateofBirth,
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
      createdAt: createdAt ?? super.createdAt,
      dateofBirth: dateofBirth ?? super.dateofBirth,
      lastActive: lastActive ?? super.lastActive,
      showOnlineStatus: showOnlineStatus ?? super.showOnlineStatus,
      phone: phone ?? super.phone,
      pushToken: pushToken ?? super.pushToken,
      userName: userName ?? super.userName,
    );
  }

  static bool _getBool(dynamic value) {
    if (value == 1) {
      return true;
    } else {
      return false;
    }
  }
}
