part of 'chat_bloc.dart';

@immutable
sealed class ChatState extends Equatable {
  const ChatState(this.chats);
  final List<Chat> chats;

  @override
  List<Object> get props => [chats];
}

class ChatInitial extends ChatState {
  const ChatInitial(super.chats);
}

class ChatLoading extends ChatState {
  const ChatLoading(super.chats);
}

class ChatLoaded extends ChatState {
  const ChatLoaded(super.chats);
}

class ChatError extends ChatState {
  final String message;

  const ChatError(super.chats, {required this.message});

  @override
  List<Object> get props => [...super.props, message];
}

class ChatFetchingMore extends ChatState {
  const ChatFetchingMore(super.chats);
}
