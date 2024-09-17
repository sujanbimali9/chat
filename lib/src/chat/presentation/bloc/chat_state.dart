part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final Map<int, Chat> chats;
  final bool isLoading;
  final bool fetchingMore;
  final String? error;

  const ChatState({
    required this.chats,
    this.isLoading = true,
    this.fetchingMore = true,
    this.error,
  });

  factory ChatState.initial() {
    return const ChatState(
      chats: {},
      isLoading: true,
      fetchingMore: true,
      error: null,
    );
  }

  ChatState copyWith({
    Map<int, Chat>? chats,
    bool? isLoading,
    bool? fetchingMore,
    String? error,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      fetchingMore: fetchingMore ?? this.fetchingMore,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [chats, isLoading, fetchingMore, error ?? ''];
}
