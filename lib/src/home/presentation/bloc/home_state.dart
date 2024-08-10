// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Map<String, User> users;
  final User? currentUser;
  final bool isLoading;
  final bool isFetchingMore;

  const HomeState({
    required this.users,
    this.currentUser,
    this.isLoading = false,
    this.isFetchingMore = false,
  });

  @override
  List<Object> get props => [];

  HomeState copyWith({
    Map<String, User>? users,
    User? currentUser,
    bool? isLoading,
    bool? isFetchingMore,
  }) {
    return HomeState(
      users: users ?? this.users,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
