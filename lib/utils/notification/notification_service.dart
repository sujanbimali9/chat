import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:chat/src/chat/data/model/chat_model.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:chat/utils/services/api_service.dart';
import 'package:chat/utils/services/socket_io.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

class NotiChat extends Equatable {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String receiverName;
  final String message;

  const NotiChat({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.message,
  });

  factory NotiChat.fromMap(Map<String, dynamic> map) => NotiChat(
    chatId: map['chatId'] as String,
    senderId: map['fromId'] as String,
    receiverId: map['toId'] as String,
    senderName: map['senderName'] as String,
    receiverName: map['receiverName'] as String,
    message: map['msg'] as String,
  );

  Map<String, dynamic> toMap() => {
    'chatId': chatId,
    'fromId': senderId,
    'toId': receiverId,
    'senderName': senderName,
    'receiverName': receiverName,
    'msg': message,
  };

  factory NotiChat.fromJson(String source) =>
      NotiChat.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
    chatId,
    senderId,
    receiverId,
    senderName,
    receiverName,
    message,
  ];
}

@pragma('vm:entry-point')
class NotificationService {
  static const int _maxMessages = 5;
  static final Map<String, ListQueue<Message>> _messageQueue = {};

  static final _notificationPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: _handleNotificationAction,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> showNotification(RemoteMessage? remoteMessage) async {
    if (remoteMessage == null) return;

    final chat = NotiChat.fromMap(remoteMessage.data);
    final sender = Person(name: chat.senderName, key: chat.senderId);
    final message = Message(chat.message, DateTime.now(), sender);
    final id = chat.chatId.hashCode;

    await _queueMessage(chat.chatId, message);
    final messages = _messageQueue[chat.chatId]!.toList();

    final style = MessagingStyleInformation(
      sender,
      conversationTitle: messages.first.text,
      messages: messages,
    );

    final androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      styleInformation: style,
      importance: Importance.max,
      priority: Priority.high,
      actions: const [
        AndroidNotificationAction(
          'reply_action',
          'Reply',
          allowGeneratedReplies: true,
          inputs: [AndroidNotificationActionInput(label: 'Type your reply')],
        ),
      ],
    );

    await _notificationPlugin.show(
      id,
      chat.senderName,
      chat.message,
      NotificationDetails(android: androidDetails),
      payload: chat.toJson(),
    );
  }

  static Future<void> _queueMessage(String key, Message message) async {
    _messageQueue.putIfAbsent(key, () => ListQueue(_maxMessages + 1));
    final queue = _messageQueue[key]!;

    final active = await _notificationPlugin.getActiveNotifications();
    final isActive = active.any((n) => n.id == key.hashCode);

    if (isActive) {
      queue.addLast(message);
      if (queue.length > _maxMessages) queue.removeFirst();
    } else {
      queue.clear();
      queue.addLast(message);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _handleNotificationAction(
    NotificationResponse response,
  ) async {
    final input = response.input;
    if (input == null) return;
    log('Input Text: $input');

    final chat = NotiChat.fromJson(response.payload!);
    final newChat = Chat(
      id: const Uuid().v4(),
      toId: chat.senderId,
      fromId: chat.receiverId,
      msg: input,
      medias: const [],
      read: false,
      sentTime: DateTime.now(),
      status: MessageStatus.sent,
      readTime: null,
      type: ChatType.text,
    );

    await _sendChat(ChatModel.fromChat(newChat));
  }

  static Future<void> _sendChat(ChatModel chat) async {
    try {
      await _ensureFirebaseInitialized();
      final auth = FirebaseAuth.instance;
      final userId = auth.currentUser?.uid;
      if (userId == null) {
        log('User not authenticated');
        return;
      }
      final token = await auth.currentUser?.getIdToken();
      if (token == null) {
        log('User token not available');
        return;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://192.168.1.22:8000/',
          headers: {
            'Authorization Bearer': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      log('Sending message: ${chat.toJson()}');
      await dio.post('chats/sendChat', data: chat.toJson());

      log('Message sent successfully');

      await LocalDatabase().chatTableQuery.insertChat(chat);
    } on ServerException catch (e) {
      log('Server Error: ${e.message}');
    } catch (e) {
      log('Unexpected Error: $e');
    }
  }

  static Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      NetworkInfo.init(Connectivity());
    }
  }
}
