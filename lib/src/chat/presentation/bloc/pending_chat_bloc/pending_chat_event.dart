part of 'pending_chat_bloc.dart';

sealed class PendingChatEvent extends Equatable {
  const PendingChatEvent();

  @override
  List<Object> get props => [];
}

class RetryPendingChats extends PendingChatEvent {}
