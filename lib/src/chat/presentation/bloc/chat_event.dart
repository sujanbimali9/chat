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

  const SendFileEvent(this.path);

  @override
  List<Object> get props => [path];
}

class SendTextEvent extends ChatEvent {
  final String text;

  const SendTextEvent(this.text);

  @override
  List<Object> get props => [text];
}

class SendImageEvent extends ChatEvent {
  final String path;

  const SendImageEvent(
    this.path,
  );

  @override
  List<Object> get props => [path];
}

class SendVideoEvent extends ChatEvent {
  final String path;

  const SendVideoEvent(this.path);

  @override
  List<Object> get props => [path];
}

class SendAudioEvent extends ChatEvent {
  final String path;
  final int? duration;

  const SendAudioEvent(this.path, {this.duration});

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

class UpdateReadEvent extends ChatEvent {
  final String chatId;

  const UpdateReadEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}
