part of 'last_chat_bloc.dart';

@freezed
class LastChatState with _$LastChatState {
  const factory LastChatState.initial() = _Initial;
  const factory LastChatState.error(String message) = _Error;
  const factory LastChatState.loaded(Map<String, Chat> chat) = _Loaded;
}
