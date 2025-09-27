part of 'conversation_history_bloc.dart';

@freezed
class ConversationHistoryEvent with _$ConversationHistoryEvent {
  const factory ConversationHistoryEvent.getConversationHistory() =
      _GetConversationHistory;
  const factory ConversationHistoryEvent.getConversationHistoryLocal() =
      _GetConversationHistoryLocal;
  const factory ConversationHistoryEvent.sortUsers(List<Chat> listChats) =
      _SortUsers;

  const factory ConversationHistoryEvent.refreshConversationHistory() =
      _RefreshConversationHistory;
  const factory ConversationHistoryEvent.fetchMoreConversationHistory() =
      _FetchMoreConversationHistory;
  const factory ConversationHistoryEvent.stateEmitter(
    ConversationHistory state,
  ) = _StateEmitter;
}
