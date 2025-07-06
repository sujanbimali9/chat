import 'package:chat/core/common/model/user.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.g.dart';
part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required final String id,
    required final String name,
    final String? email,
    required final String profileImage,
    required final DateTime createdAt,
    required final DateTime lastActive,
    @Default(true) final bool isOnline,
    required final bool showOnlineStatus,
    final String? phone,
  }) = _UserModel;

  factory UserModel.fromJson(json) => _$UserModelFromJson(json);

  factory UserModel.fromSupabaseUser(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['user_metadata']['name'],
      email: json['user_metadata']['email'],
      profileImage: json['user_metadata']['avatar_url'] ??
          json['user_metadata']['picture'] ??
          '',
      createdAt: DateTime.parse(json['created_at']),
      lastActive: DateTime.now(),
      showOnlineStatus: true,
      phone: json['phone'],
    );
  }

  factory UserModel.fromUser(User user) {
    return UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        profileImage: user.profileImage,
        createdAt: user.createdAt,
        lastActive: user.lastActive,
        showOnlineStatus: user.showOnlineStatus,
        phone: user.phone);
  }
  factory UserModel.fromUserEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      name: user.name,
      profileImage: user.profileImage,
      createdAt: user.createdAt,
      lastActive: user.lastActive,
      showOnlineStatus: user.showOnlineStatus,
    );
  }
}
