// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String profileImage;
  final bool showOnlineStatus;
  final List<String> blocked;
  final String fullName;
  final String userName;
  final String phone;
  final String about;
  final String createdAt;
  final String lastActive;
  final bool isOnline;
  final String id;
  final String pushToken;
  final String email;
  final List<String> friends;
  final String dateofBirth;

  const User({
    required this.profileImage,
    required this.showOnlineStatus,
    required this.blocked,
    required this.fullName,
    required this.userName,
    required this.phone,
    required this.about,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.pushToken,
    required this.email,
    required this.friends,
    required this.dateofBirth,
  });

  @override
  List<Object?> get props => [
        profileImage,
        showOnlineStatus,
        blocked,
        fullName,
        userName,
        phone,
        about,
        createdAt,
        lastActive,
        isOnline,
        id,
        pushToken,
        email,
        friends,
        dateofBirth,
      ];

  User copyWith({
    String? profileImage,
    bool? showOnlineStatus,
    List<String>? blocked,
    String? fullName,
    String? userName,
    String? phone,
    String? about,
    String? createdAt,
    String? lastActive,
    bool? isOnline,
    String? id,
    String? pushToken,
    String? email,
    List<String>? friends,
    String? dateofBirth,
  }) {
    return User(
      profileImage: profileImage ?? this.profileImage,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      blocked: blocked ?? this.blocked,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      about: about ?? this.about,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
      id: id ?? this.id,
      pushToken: pushToken ?? this.pushToken,
      email: email ?? this.email,
      friends: friends ?? this.friends,
      dateofBirth: dateofBirth ?? this.dateofBirth,
    );
  }
}
