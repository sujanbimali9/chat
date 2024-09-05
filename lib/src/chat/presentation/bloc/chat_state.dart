part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final Map<int, Chat> chats;
  final bool isLoading;
  final bool fetchingMore;
  final String? error;
  final Map<int, Chat>? pendingChats;

  const ChatState({
    required this.chats,
    this.isLoading = true,
    this.fetchingMore = true,
    this.error,
    this.pendingChats,
  });

  factory ChatState.initial() {
    return const ChatState(
      chats: {},
      isLoading: true,
      fetchingMore: true,
      error: null,
      pendingChats: {},
    );
  }

  ChatState copyWith({
    Map<int, Chat>? chats,
    bool? isLoading,
    bool? fetchingMore,
    String? error,
    Map<int, Chat>? pendingChats,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      fetchingMore: fetchingMore ?? this.fetchingMore,
      error: error ?? this.error,
      pendingChats: pendingChats ?? this.pendingChats,
    );
  }

  @override
  List<Object> get props => [chats, isLoading, fetchingMore, error ?? ''];
}
