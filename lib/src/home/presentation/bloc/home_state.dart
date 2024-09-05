// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Map<String, User> users;
  final Map<String, Chat> lastChats;
  final User? currentUser;
  final bool isLoading;
  final bool isFetchingMore;

  const HomeState({
    required this.lastChats,
    required this.users,
    this.currentUser,
    this.isLoading = false,
    this.isFetchingMore = false,
  });

  @override
  List<Object> get props => [
        users,
        currentUser ?? '',
        isLoading,
        isFetchingMore,
        lastChats,
      ];

  HomeState copyWith({
    Map<String, User>? users,
    User? currentUser,
    bool? isLoading,
    bool? isFetchingMore,
    Map<String, Chat>? lastChats,
  }) {
    return HomeState(
      users: users ?? this.users,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      lastChats: lastChats ?? this.lastChats,
    );
  }
}
