import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/chat_metadata.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/domain/usecase/get_chat.dart';
import 'package:chat/src/chat/domain/usecase/get_chat_stream.dart';
import 'package:chat/src/chat/domain/usecase/remove_chat.dart';
import 'package:chat/src/chat/domain/usecase/send_audio.dart';
import 'package:chat/src/chat/domain/usecase/send_file.dart';
import 'package:chat/src/chat/domain/usecase/send_image.dart';
import 'package:chat/src/chat/domain/usecase/send_text.dart';
import 'package:chat/src/chat/domain/usecase/send_video.dart';
import 'package:chat/src/utils/generator/id_generator.dart';
import 'package:chat/src/utils/generator/list/extensions.dart';
import 'package:chat/src/utils/generator/media/image_metadata.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatStreamUseCase _getChatStreamUseCase;
  final RemoveChatUseCase _removeChatUseCase;
  final SendAudioUseCase _sendAudioUseCase;
  final SendVideoUseCase _sendVideoUseCase;
  final SendTextUseCase _sendTextUseCase;
  final SendImageUseCase _sendImageUseCase;
  final SendFileUseCase _sendFileUseCase;
  final GetChatUseCase _getChatsUseCase;
  final String _chatId;
  final String _userId;
  final String _currentUserId;
  bool allChatsLoaded = false;
  int? _lastDocId;

  ChatBloc(
    GetChatStreamUseCase getChatStreamUseCase,
    RemoveChatUseCase removeChatUseCase,
    SendAudioUseCase sendAudioUseCase,
    SendVideoUseCase sendVideoUseCase,
    SendTextUseCase sendTextUseCase,
    SendImageUseCase sendImageUseCase,
    SendFileUseCase sendFileUseCase,
    GetChatUseCase getChatUseCase, {
    required String userId,
    required String currentUserId,
  })  : _getChatStreamUseCase = getChatStreamUseCase,
        _removeChatUseCase = removeChatUseCase,
        _sendAudioUseCase = sendAudioUseCase,
        _sendVideoUseCase = sendVideoUseCase,
        _sendTextUseCase = sendTextUseCase,
        _sendImageUseCase = sendImageUseCase,
        _sendFileUseCase = sendFileUseCase,
        _getChatsUseCase = getChatUseCase,
        _currentUserId = currentUserId,
        _userId = userId,
        _chatId = IdGenerator.getConversionId(userId, currentUserId),
        super(ChatState.initial()) {
    _listenForNewChats();
    _listenForConnectivity();

    on<FetchMessagesEvent>(_onFetchMessages);
    on<SendFileEvent>(_onSendFile);
    on<SendTextEvent>(_onSendText);
    on<SendImageEvent>(_onSendImage);
    on<SendVideoEvent>(_onSendVideo);
    on<RemoveChatEvent>(_onRemoveChat);
  }

  Future<void> _onFetchMessages(
      FetchMessagesEvent event, Emitter<ChatState> emit) async {
    if (allChatsLoaded) return;
    emit(state.copyWith(fetchingMore: true));

    final result = await _getChatsUseCase(GetChatParms(
      chatId: _chatId,
      limit: event.limit,
      offset: _lastDocId,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
          fetchingMore: false,
          error: failure.message,
        ));
      },
      (chats) {
        if (chats.isEmpty || chats.values.length < event.limit) {
          allChatsLoaded = true;
        } else {
          _lastDocId = chats.values.last.sentTime;
        }

        emit(state.copyWith(
          chats: {...state.chats, ...chats},
          fetchingMore: false,
        ));
      },
    );
  }

  Future<void> _onSendFile(SendFileEvent event, Emitter<ChatState> emit) async {
    final fileType = _fileType(event.path);
    if (fileType.isImage) {
      add(SendImageEvent(event.path));
    } else if (fileType.isVideo) {
      add(SendVideoEvent(event.path));
    } else if (fileType.isAudio) {
      add(SendAudioEvent(event.path));
    } else {
      final chat = Chat(
        id: const Uuid().v4(),
        msg: event.path,
        toId: _userId,
        read: false,
        type: ChatType.file,
        fromId: _currentUserId,
        readTime: null,
        sentTime: DateTime.now().millisecondsSinceEpoch,
        metadata: null,
        status: MessageStatus.sending,
      );
      emit(state.copyWith(
        chats: {...state.chats, chat.sentTime: chat},
      ));
      final res = await _sendFileUseCase(chat);
      res.fold(
        (failure) {
          emit(state.copyWith(
            pendingChats: {
              ...?state.pendingChats,
              chat.sentTime: chat,
            },
          ));
        },
        (chat) {
          emit(state.copyWith(
            chats: {...state.chats, chat.sentTime: chat},
          ));
        },
      );
    }
  }

  Future<void> _onSendText(SendTextEvent event, Emitter<ChatState> emit) async {
    final chat = Chat(
      id: const Uuid().v4(),
      msg: event.text,
      toId: _userId,
      read: false,
      type: ChatType.text,
      fromId: _currentUserId,
      readTime: null,
      sentTime: DateTime.now().millisecondsSinceEpoch,
      metadata: null,
      status: MessageStatus.sending,
    );
    final res = await _sendTextUseCase(chat);
    res.fold(
      (failure) {
        emit(state.copyWith(
          pendingChats: {
            ...?state.pendingChats,
            chat.sentTime: chat,
          },
        ));
      },
      (chat) {
        emit(state.copyWith(
          chats: {...state.chats, chat.sentTime: chat},
        ));
      },
    );
  }

  Future<void> _onSendImage(
      SendImageEvent event, Emitter<ChatState> emit) async {
    final compressedImage = await compressImage(event.path);
    final double aspectRatio = await getImageAspectRatio(compressedImage);
    final title = event.path.split('/').last;
    final chat = Chat(
      id: const Uuid().v4(),
      msg: event.path,
      toId: _userId,
      read: false,
      type: ChatType.text,
      fromId: _currentUserId,
      readTime: null,
      sentTime: DateTime.now().millisecondsSinceEpoch,
      metadata: ChatMetaData(
        aspectRatio: aspectRatio,
        title: title,
      ),
      status: MessageStatus.sending,
    );

    emit(state.copyWith(
      chats: {...state.chats, chat.sentTime: chat},
    ));

    final res = await _sendImageUseCase(chat);
    res.fold(
      (failure) {
        emit(state.copyWith(
          pendingChats: {
            ...?state.pendingChats,
            chat.sentTime: chat,
          },
        ));
      },
      (chat) {
        emit(state.copyWith(
          chats: {...state.chats, chat.sentTime: chat},
        ));
      },
    );
  }

  Future<void> _onSendVideo(
      SendVideoEvent event, Emitter<ChatState> emit) async {
    final String title = event.path.split('/').last;
    final thumbnail = await getVideoThumbnail(event.path);
    final double aspectRatio = await getImageAspectRatio(thumbnail);
    final chat = Chat(
      id: const Uuid().v4(),
      msg: event.path,
      toId: _userId,
      read: false,
      type: ChatType.video,
      fromId: _currentUserId,
      readTime: null,
      sentTime: DateTime.now().millisecondsSinceEpoch,
      metadata: ChatMetaData(
        aspectRatio: aspectRatio,
        title: title,
        thumbnail: getImageUrl(title),
      ),
      status: MessageStatus.sending,
    );

    emit(state.copyWith(
      chats: {...state.chats, chat.sentTime: chat},
    ));
    final res = await _sendVideoUseCase(chat);

    res.fold(
      (failure) {
        emit(state.copyWith(
          pendingChats: {
            ...?state.pendingChats,
            chat.sentTime: chat,
          },
        ));
      },
      (chat) {
        emit(state.copyWith(
          chats: {...state.chats, chat.sentTime: chat},
        ));
      },
    );
  }

  void _listenForNewChats({int? limit}) {}

  void _listenForConnectivity() {}
  ChatType _fileType(String name) {
    final fileExtension = name.split('.').last;
    if (imageExtensions.contains(fileExtension)) {
      return ChatType.image;
    } else if (videoExtension.contains(fileExtension)) {
      return ChatType.video;
    } else {
      return ChatType.file;
    }
  }

  Future<Uint8List> compressImage(String path) async {
    final image = await ImageMetadata.compressImage(path);
    if (image == null) {
      throw Exception('Failed to compress image');
    }
    return image;
  }

  Future<double> getImageAspectRatio(Uint8List compressedImage) {
    final aspectRatio =
        ImageMetadata.getImageAspectRatio(rawBytes: compressedImage);
    // if (aspectRatio == null) {
    //   throw Exception('Failed to get image aspect ratio');
    // }
    return aspectRatio;
  }

  Future<Uint8List> getVideoThumbnail(String path) async {
    final thumbnail = await VideoThumbnail.thumbnailData(video: path);
    if (thumbnail == null) {
      throw Exception('Failed to get video thumbnail');
    }
    return thumbnail;
  }

  String getImageUrl(String title) {
    return 'https: //mvjqpjnwibunwedtogmw.supabase.co/storage/v1/object/public/thumbnail/$title';
  }

  FutureOr<void> _onRemoveChat(
      RemoveChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      chats: state.chats..remove(event.chat.sentTime),
    ));
    final res = await _removeChatUseCase(event.chat);
    res.fold(
      (failure) {
        emit(state.copyWith(
          chats: state.chats
            ..putIfAbsent(event.chat.sentTime, () => event.chat),
        ));
      },
      (chat) {},
    );
  }
}
