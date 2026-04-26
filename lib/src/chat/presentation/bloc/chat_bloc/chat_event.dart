part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchMore extends ChatEvent {
  const FetchMore();
}

class SendChat extends ChatEvent {
  const SendChat(this.text, {required this.type, this.medias, this.mediaType});

  final String text;
  final ChatType type;
  final List<String>? medias;
  final MediaType? mediaType;

  @override
  List<Object> get props => [text, type, medias ?? [], mediaType ?? ''];
}

class StateEmitter extends ChatEvent {
  const StateEmitter({required this.state});

  final ChatState state;
}

class ListenForNewChats extends ChatEvent {
  const ListenForNewChats();
}

class SwitchChat extends ChatEvent {
  const SwitchChat(this.userId, this.currentUserId);

  final String userId;
  final String currentUserId;

  @override
  List<Object> get props => [userId, currentUserId];
}
