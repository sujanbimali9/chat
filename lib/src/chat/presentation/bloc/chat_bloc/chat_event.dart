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
  const SendChat(
    this.text, {
    required this.type,
    this.medias,
    this.mediaType,
  });

  final String text;
  final ChatType type;
  final List<String>? medias;
  final MediaType? mediaType;

  @override
  List<Object> get props => [text, type, medias ?? [], mediaType ?? ''];
}

class UpdateReadStatus extends ChatEvent {
  const UpdateReadStatus({
    required this.chatId,
    required this.userId,
  });

  final String chatId;
  final String userId;

  @override
  List<Object> get props => [chatId, userId];
}

class StateEmitter extends ChatEvent {
  const StateEmitter({
    required this.state,
  });

  final ChatState state;
}

class ListenForNewChats extends ChatEvent {
  const ListenForNewChats();
}
