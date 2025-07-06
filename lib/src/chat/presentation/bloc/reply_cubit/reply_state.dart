part of 'reply_cubit.dart';

sealed class ReplyState extends Equatable {
  const ReplyState();

  @override
  List<Object> get props => [];
}

class ReplyInitial extends ReplyState {
  const ReplyInitial();
}

class Replying extends ReplyState {
  final Chat chat;

  const Replying(this.chat);

  @override
  List<Object> get props => [chat];
}
