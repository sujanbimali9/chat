import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:equatable/equatable.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  ReplyCubit() : super(const ReplyInitial());

  void replyTo(Chat chat) {
    emit(Replying(chat));
  }

  void cancelReply() {
    emit(const ReplyInitial());
  }

  bool isReplying() {
    return state is Replying;
  }
}
