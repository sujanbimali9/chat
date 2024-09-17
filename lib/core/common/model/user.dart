// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String profileImage;
  final bool showOnlineStatus;
  final String fullName;
  final String userName;
  final String phone;
  final String about;
  final String createdAt;
  final String lastActive;
  final String id;
  final String pushToken;
  final String email;
  final String dateofBirth;

  const User({
    required this.profileImage,
    required this.showOnlineStatus,
    required this.fullName,
    required this.userName,
    required this.phone,
    required this.about,
    required this.createdAt,
    required this.lastActive,
    required this.id,
    required this.pushToken,
    required this.email,
    required this.dateofBirth,
  });

  @override
  List<Object?> get props => [
        profileImage,
        showOnlineStatus,
        fullName,
        userName,
        phone,
        about,
        createdAt,
        lastActive,
        id,
        pushToken,
        email,
        dateofBirth,
      ];

  User copyWith({
    String? profileImage,
    bool? showOnlineStatus,
    String? fullName,
    String? userName,
    String? phone,
    String? about,
    String? createdAt,
    String? lastActive,
    String? id,
    String? pushToken,
    String? email,
    String? dateofBirth,
  }) {
    return User(
      profileImage: profileImage ?? this.profileImage,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      about: about ?? this.about,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      id: id ?? this.id,
      pushToken: pushToken ?? this.pushToken,
      email: email ?? this.email,
      dateofBirth: dateofBirth ?? this.dateofBirth,
    );
  }
}
