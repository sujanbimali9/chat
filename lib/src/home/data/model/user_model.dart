import 'package:chat/core/common/model/user.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.g.dart';
part 'user_model.freezed.dart';

@freezed
class UserModel extends User with _$UserModel {
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

  factory UserModel.fromJson(dynamic json) => _$UserModelFromJson(json);

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

  factory UserModel.fromUser(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      profileImage: user.profileImage,
      createdAt: user.createdAt,
      lastActive: user.lastActive,
      isOnline: user.isOnline,
      showOnlineStatus: user.showOnlineStatus,
      phone: user.phone,
    );
  }
}
