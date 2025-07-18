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

  static Future<void> init() async {
    final notificationPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: _handleNotificationAction,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> showNotification(RemoteMessage? remoteMessage) async {
    if (remoteMessage == null) return;

    final notificationPlugin = FlutterLocalNotificationsPlugin();
    final messageData = remoteMessage.data;
    final chatNotification = NotiChat.fromMap(messageData);
    final messageKey = chatNotification.chatId;

    final activeNotifications = await notificationPlugin
        .getActiveNotifications();

    final isActiveMessages =
        activeNotifications.isNotEmpty &&
        activeNotifications.any((n) => n.id == messageKey.hashCode);

    _messageQueue.putIfAbsent(messageKey, () => ListQueue(_maxMessages + 1));

    final sender = Person(
      name: chatNotification.senderName,
      key: chatNotification.senderId,
    );

    final message = Message(chatNotification.message, DateTime.now(), sender);

    if (isActiveMessages) {
      _messageQueue[messageKey]!.addLast(message);
      if (_messageQueue[messageKey]!.length > _maxMessages) {
        _messageQueue[messageKey]!.removeFirst();
      }
    } else {
      _messageQueue[messageKey]!.clear();
      _messageQueue[messageKey]!.addLast(message);
    }

    final messageList = _messageQueue[messageKey]!.toList();

    final inboxStyleInformation = MessagingStyleInformation(
      sender,
      conversationTitle: messageList.first.text,
      messages: messageList,
    );

    final androidNotification = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      styleInformation: inboxStyleInformation,
      actions: const [
        AndroidNotificationAction(
          'reply_action',
          'Reply',
          allowGeneratedReplies: true,
          inputs: [
            AndroidNotificationActionInput(label: 'Type your reply here'),
          ],
        ),
      ],
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidNotification,
    );

    await notificationPlugin.show(
      messageKey.hashCode,
      sender.name,
      message.text,
      notificationDetails,
      payload: chatNotification.toJson(),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _handleNotificationAction(
    NotificationResponse response,
  ) async {
    final inputText = response.input;
    log('Input Text: $inputText');

    if (inputText == null) return;

    final chatNotification = NotiChat.fromJson(response.payload!);

    final chat = Chat(
      id: const Uuid().v4(),
      toId: chatNotification.senderId,
      fromId: chatNotification.receiverId,
      msg: inputText,
      medias: const [],
      read: false,
      sentTime: DateTime.now(),
      status: MessageStatus.sent,
      readTime: null,
      type: ChatType.text,
    );

    try {
      final chatModel = ChatModel.fromChat(chat);

      final connectivity = Connectivity();
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        NetworkInfo.init(connectivity);
      }

      final firebaseAuth = FirebaseAuth.instance;
      final apiService = ApiService.init(
        firebaseAuth,
        'http://192.168.1.22:8000/',
      );
      final socketIO = SocketIOService();

      final chatRemoteDataSource = ChatRemoteDataSourceImp(
        apiService,
        socketIO,
      );

      log('sending message: ${chatModel.toJson()}');
      await chatRemoteDataSource.sendMessageHttp(chatModel);
      log('message sent successfully');

      final localDatabase = LocalDatabase();
      await localDatabase.chatTableQuery.insertChat(chatModel);
    } on ServerException catch (e) {
      log('Error sending message Http: ${e.message}');
    } catch (e) {
      log('Error: $e');
    }
  }
}
