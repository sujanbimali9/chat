part of 'last_chat_bloc.dart';

@freezed
class LastChatEvent with _$LastChatEvent {
  const factory LastChatEvent.getLastChats() = _GetLastChats;
  const factory LastChatEvent.refreshLastChat() = _RefreshLastChat;
  const factory LastChatEvent.streamLastChat() = _StreamLastChat;
}
