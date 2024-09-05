import 'package:bloc_test/bloc_test.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/common/model/chat_metadata.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/src/chat/domain/usecase/get_chat.dart';
import 'package:chat/src/chat/domain/usecase/get_chat_stream.dart';
import 'package:chat/src/chat/domain/usecase/remove_chat.dart';
import 'package:chat/src/chat/domain/usecase/send_audio.dart';
import 'package:chat/src/chat/domain/usecase/send_file.dart';
import 'package:chat/src/chat/domain/usecase/send_image.dart';
import 'package:chat/src/chat/domain/usecase/send_text.dart';
import 'package:chat/src/chat/domain/usecase/send_video.dart';
import 'package:chat/src/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSendTextUseCase extends Mock implements SendTextUseCase {}

class MockSendAudioUseCase extends Mock implements SendAudioUseCase {}

class MockSendVideoUseCase extends Mock implements SendVideoUseCase {}

class MockSendImageUseCase extends Mock implements SendImageUseCase {}

class MockSendFileUseCase extends Mock implements SendFileUseCase {}

class MockGetChatStreamUseCase extends Mock implements GetChatStreamUseCase {}

class MockRemoveChatUseCase extends Mock implements RemoveChatUseCase {}

class MockGetChatUseCase extends Mock implements GetChatUseCase {}

class ChatFake extends Fake implements Chat {}

void main() {
  late ChatBloc chatBloc;
  late MockSendTextUseCase mockSendTextUseCase;
  late MockSendAudioUseCase mockSendAudioUseCase;
  late MockSendVideoUseCase mockSendVideoUseCase;
  late MockSendImageUseCase mockSendImageUseCase;
  late MockSendFileUseCase mockSendFileUseCase;
  late MockGetChatStreamUseCase mockGetChatStreamUseCase;
  late MockRemoveChatUseCase mockRemoveChatUseCase;
  late MockGetChatUseCase mockGetChatUseCase;

  setUpAll(() {
    registerFallbackValue(ChatFake());
  });

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    mockSendTextUseCase = MockSendTextUseCase();
    mockSendAudioUseCase = MockSendAudioUseCase();
    mockSendVideoUseCase = MockSendVideoUseCase();
    mockSendImageUseCase = MockSendImageUseCase();
    mockSendFileUseCase = MockSendFileUseCase();
    mockGetChatStreamUseCase = MockGetChatStreamUseCase();
    mockRemoveChatUseCase = MockRemoveChatUseCase();
    mockGetChatUseCase = MockGetChatUseCase();

    chatBloc = ChatBloc(
      mockGetChatStreamUseCase,
      mockRemoveChatUseCase,
      mockSendAudioUseCase,
      mockSendVideoUseCase,
      mockSendTextUseCase,
      mockSendImageUseCase,
      mockSendFileUseCase,
      mockGetChatUseCase,
      userId: 'userId',
      currentUserId: 'currentUserId',
    );
  });

  tearDown(() {
    chatBloc.close();
  });
  const chatId = 'const Uuid().v4()';
  const sentTimestamp = 1234567890;
  blocTest<ChatBloc, ChatState>(
    'emits [sending, sent] when SendTextEvent is added',
    build: () {
      when(() => mockSendTextUseCase(any())).thenAnswer(
        (_) async => right(Chat(
          id: chatId,
          msg: 'Hello',
          toId: 'userId',
          fromId: 'currentUserId',
          type: ChatType.text,
          sentTime: sentTimestamp,
          status: MessageStatus.sent,
          read: false,
          readTime: null,
          metadata: null,
        )),
      );
      return chatBloc;
    },
    act: (bloc) => bloc.add(const SendTextEvent('Hello')),
    expect: () => [
      ChatState(
        chats: {
          sentTimestamp: Chat(
            id: chatId,
            msg: 'Hello',
            toId: 'userId',
            fromId: 'currentUserId',
            type: ChatType.text,
            sentTime: sentTimestamp,
            status: MessageStatus.sending,
            read: false,
            readTime: null,
            metadata: null,
          ),
        },
        error: null,
        pendingChats: null,
      ),
      ChatState(
        chats: {
          sentTimestamp: Chat(
            id: chatId,
            msg: 'Hello',
            toId: 'userId',
            fromId: 'currentUserId',
            type: ChatType.text,
            sentTime: sentTimestamp,
            status: MessageStatus.sent,
            read: false,
            readTime: null,
            metadata: null,
          ),
        },
        error: null,
        pendingChats: null,
      ),
    ],
  );

  blocTest<ChatBloc, ChatState>(
    'emits [sending, sent] when SendAudioEvent is added',
    build: () {
      when(() => mockSendAudioUseCase(any())).thenAnswer(
        (_) async => right(Chat(
          id: 'const Uuid().v4()',
          msg: 'audio_path/audio-title',
          toId: 'userId',
          fromId: 'currentUserId',
          type: ChatType.audio,
          sentTime: sentTimestamp,
          status: MessageStatus.sent,
          read: false,
          readTime: null,
          metadata: const ChatMetaData(
            title: 'audio_title',
            duration: 60,
          ),
        )),
      );

      return chatBloc;
    },
    act: (bloc) => bloc.add(const SendAudioEvent('audio_path', duration: 60)),
    expect: () => [
      ChatState(
        chats: {
          sentTimestamp: Chat(
            id: 'const Uuid().v4()',
            msg: 'audio_path/audio-title',
            toId: 'userId',
            fromId: 'currentUserId',
            type: ChatType.audio,
            sentTime: sentTimestamp,
            status: MessageStatus.sending,
            read: false,
            readTime: null,
            metadata: const ChatMetaData(
              title: 'audio_title',
              duration: 60,
            ),
          ),
        },
        error: null,
        pendingChats: null,
      ),
      ChatState(
        chats: {
          sentTimestamp: Chat(
            id: 'const Uuid().v4()',
            msg: 'audio_path/audio-title',
            toId: 'userId',
            fromId: 'currentUserId',
            type: ChatType.audio,
            sentTime: sentTimestamp,
            status: MessageStatus.sent,
            read: false,
            readTime: null,
            metadata: const ChatMetaData(
              title: 'audio_title',
              duration: 60,
            ),
          ),
        },
        error: null,
        pendingChats: null,
      ),
    ],
  );

  blocTest<ChatBloc, ChatState>(
    'emits [sending, sent] when SendVideoEvent is added',
    build: () {
      when(() => mockSendVideoUseCase(any())).thenAnswer(
        (_) async => right(Chat(
          id: '3',
          msg: 'video_path',
          toId: 'userId',
          fromId: 'currentUserId',
          type: ChatType.video,
          sentTime: sentTimestamp,
          status: MessageStatus.sent,
          read: false,
          readTime: null,
          metadata: const ChatMetaData(
            title: 'video_title',
            aspectRatio: 16 / 9,
            thumbnail: 'thumbnail_path',
          ),
        )),
      );

      return chatBloc;
    },
    act: (bloc) => bloc.add(const SendVideoEvent('video_path/video-title')),
    expect: () => [
      ChatState(
        chats: {
          sentTimestamp: Chat(
            id: '3',
            msg: 'video_path',
            toId: 'userId',
            fromId: 'currentUserId',
            type: ChatType.video,
            sentTime: sentTimestamp,
            status: MessageStatus.sending,
            read: false,
            readTime: null,
            metadata: const ChatMetaData(
              title: 'video_title',
              aspectRatio: 16 / 9,
              thumbnail: 'thumbnail_path',
            ),
          ),
        },
        error: null,
        pendingChats: null,
      ),
      ChatState(
        chats: {
          sentTimestamp: Chat(
            id: '3',
            msg: 'video_path',
            toId: 'userId',
            fromId: 'currentUserId',
            type: ChatType.video,
            sentTime: sentTimestamp,
            status: MessageStatus.sent,
            read: false,
            readTime: null,
            metadata: const ChatMetaData(
              title: 'video_title',
              aspectRatio: 16 / 9,
              thumbnail: 'thumbnail_path',
            ),
          ),
        },
        error: null,
        pendingChats: null,
      ),
    ],
  );

  blocTest<ChatBloc, ChatState>(
    'emits [sending, sent] when SendFileEvent is added',
    build: () {
      when(() => mockSendFileUseCase(any())).thenAnswer(
        (_) async => right(Chat(
          id: '5',
          msg: 'file_path',
          toId: 'userId',
          fromId: 'currentUserId',
          type: ChatType.file,
          sentTime: sentTimestamp,
          status: MessageStatus.sent,
          read: false,
          readTime: null,
          metadata: const ChatMetaData(
            title: 'file_title',
          ),
        )),
      );

      return chatBloc;
    },
    act: (bloc) => bloc.add(const SendFileEvent('file_path')),
    expect: () => [
      ChatState(
        chats: {
          sentTimestamp: Chat(
            id: '5',
            msg: 'file_path',
            toId: 'userId',
            fromId: 'currentUserId',
            type: ChatType.file,
            sentTime: sentTimestamp,
            status: MessageStatus.sending,
            read: false,
            readTime: null,
            metadata: const ChatMetaData(
              title: 'file_title',
            ),
          ),
        },
        error: null,
        pendingChats: null,
      ),
      ChatState(
        chats: {
          sentTimestamp: Chat(
            id: '5',
            msg: 'file_path',
            toId: 'userId',
            fromId: 'currentUserId',
            type: ChatType.file,
            sentTime: sentTimestamp,
            status: MessageStatus.sent,
            read: false,
            readTime: null,
            metadata: const ChatMetaData(
              title: 'file_title',
            ),
          ),
        },
        error: null,
        pendingChats: null,
      ),
    ],
  );
}
