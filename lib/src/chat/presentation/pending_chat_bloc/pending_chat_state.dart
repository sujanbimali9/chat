part of 'pending_chat_bloc.dart';

sealed class PendingChatState extends Equatable {
  const PendingChatState();
  
  @override
  List<Object> get props => [];
}

final class PendingChatInitial extends PendingChatState {}
