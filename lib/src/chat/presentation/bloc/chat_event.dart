part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchMessagesEvent extends ChatEvent {
  final int limit;

  const FetchMessagesEvent({this.limit = 10});

  @override
  List<Object> get props => [limit];
}

class SendFileEvent extends ChatEvent {
  final String path;
  final Chat? chat;

  const SendFileEvent(this.path, {this.chat});

  @override
  List<Object> get props => [path, chat ?? ''];
}

class SendTextEvent extends ChatEvent {
  final String text;
  final Chat? chat;

  const SendTextEvent(this.text, {this.chat});

  @override
  List<Object> get props => [text, chat ?? ''];
}

class SendImageEvent extends ChatEvent {
  final String path;
  final Chat? chat;

  const SendImageEvent(this.path, {this.chat});

  @override
  List<Object> get props => [path, chat ?? ''];
}

class SendVideoEvent extends ChatEvent {
  final String path;
  final Chat? chat;

  const SendVideoEvent(this.path, {this.chat});

  @override
  List<Object> get props => [path, chat ?? ''];
}

class SendAudioEvent extends ChatEvent {
  final String path;
  final int? duration;
  final Chat? chat;

  const SendAudioEvent(this.path, {this.chat, this.duration});

  @override
  List<Object> get props => [path];
}

class RemoveChatEvent extends ChatEvent {
  final Chat chat;

  const RemoveChatEvent(this.chat);

  @override
  List<Object> get props => [chat];
}

class _StateEmitter extends ChatEvent {
  final ChatState state;

  const _StateEmitter({required this.state});
}
