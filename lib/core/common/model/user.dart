import 'package:chat/src/home/data/model/user_model.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String profileImage;
  final DateTime createdAt;
  final DateTime lastActive;
  final bool isOnline;
  final bool showOnlineStatus;
  final String? phone;

  const User({
    required this.profileImage,
    required this.showOnlineStatus,
    required this.name,
    this.isOnline = true,
    required this.phone,
    required this.createdAt,
    required this.lastActive,
    required this.id,
    required this.email,
  });

  @override
  List<Object?> get props => [
        profileImage,
        showOnlineStatus,
        name,
        phone,
        createdAt,
        lastActive,
        isOnline,
        id,
        email,
      ];

  User copyWith({
    String? profileImage,
    bool? showOnlineStatus,
    String? name,
    bool? isOnline,
    String? phone,
    DateTime? createdAt,
    DateTime? lastActive,
    String? id,
    String? email,
  }) {
    return User(
      profileImage: profileImage ?? this.profileImage,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  factory User.fromUserModel(UserModel res) {
    return User(
      profileImage: res.profileImage,
      showOnlineStatus: true,
      name: res.name,
      phone: res.phone,
      createdAt: res.createdAt,
      lastActive: res.lastActive,
      isOnline: true,
      id: res.id,
      email: res.email,
    );
  }
}
