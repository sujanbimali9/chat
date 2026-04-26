part of 'conversation_history_bloc.dart';

@freezed
class ConversationHistoryEvent with _$ConversationHistoryEvent {
  const factory ConversationHistoryEvent.getConversationHistory() =
      _GetConversationHistory;
  const factory ConversationHistoryEvent.refreshConversationHistory() =
      _RefreshConversationHistory;
  const factory ConversationHistoryEvent.fetchMoreConversationHistory() =
      _FetchMoreConversationHistory;
  const factory ConversationHistoryEvent.updateFromStream(
    List<Conversation> conversations,
  ) = _StateEmitter;
}
