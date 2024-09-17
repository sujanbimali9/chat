import 'dart:convert';
import 'dart:developer';
import 'package:chat/.supabase_key.dart';
import 'package:chat/core/common/model/chat.dart';
import 'package:chat/core/enum/chat_type.dart';
import 'package:chat/src/chat/data/data_source/chat_remote_data_source.dart';
import 'package:chat/src/chat/data/data_source/local_remote_data_source.dart';
import 'package:chat/src/chat/data/repository/chat_repository_imp.dart';
import 'package:chat/src/chat/domain/usecase/send_text.dart';
import 'package:chat/utils/database/local_database.dart';
import 'package:chat/utils/helper/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:collection';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chatId,
      'from_id': senderId,
      'to_id': receiverId,
      'sender_name': senderName,
      'receiver_name': receiverName,
      'msg': message,
    };
  }

  factory NotiChat.fromMap(Map<String, dynamic> map) {
    return NotiChat(
      chatId: map['chat_id'] as String,
      senderId: map['from_id'] as String,
      receiverId: map['to_id'] as String,
      senderName: map['sender_name'] as String,
      receiverName: map['receiver_name'] as String,
      message: map['msg'] as String,
    );
  }
  String toJson() => json.encode(toMap());

  factory NotiChat.fromJson(String source) =>
      NotiChat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props =>
      [chatId, senderId, receiverId, senderName, receiverName, message];
}

class NotificationService {
  static final _messageQueue = <String, ListQueue<Message>>{};
  static const int _maxMessages = 5;
  static bool _isInitialize = false;

  static Future<void> init() async {
    final notificationPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await notificationPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: _handleNotificationAction);
  }

  @pragma('vm:entry-point')
  static Future<void> showNotification(RemoteMessage? remoteMessage) async {
    final notificationPlugin = FlutterLocalNotificationsPlugin();
    if (remoteMessage == null) return;
    final messageData = remoteMessage.data;

    final chatNotification = NotiChat.fromMap(messageData);
    final messageKey = chatNotification.chatId;

    final activeNotification =
        await notificationPlugin.getActiveNotifications();

    final bool isActiveMessages = activeNotification.isNotEmpty &&
        activeNotification.any((element) => element.id == messageKey.hashCode);

    _messageQueue.putIfAbsent(messageKey, () => ListQueue(_maxMessages + 1));

    final sender = Person(
      name: chatNotification.senderName,
      key: chatNotification.senderId,
    );

    final message = Message(
      chatNotification.message,
      DateTime.now(),
      sender,
    );

    if (isActiveMessages) {
      _messageQueue[messageKey]?.addLast(message);
      if (_messageQueue[messageKey]!.length > _maxMessages) {
        _messageQueue[messageKey]?.removeFirst();
      }
    } else {
      _messageQueue[messageKey]?.clear();
      _messageQueue[messageKey]?.addLast(message);
    }

    List<Message> messageList = _messageQueue[messageKey]!.toList();

    final inboxStyleInformation = MessagingStyleInformation(
      sender,
      // groupConversation: true,
      conversationTitle: messageList.first.text,
      messages: messageList,
    );

    var androidNotification = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      styleInformation: inboxStyleInformation,
      actions: [
        const AndroidNotificationAction(
          'reply_action',
          'Reply',
          allowGeneratedReplies: true,
          inputs: [
            AndroidNotificationActionInput(
              label: 'Type your reply here',
            ),
          ],
        ),
      ],
      importance: Importance.max,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(
      android: androidNotification,
    );

    await notificationPlugin.show(
      remoteMessage.data['chat_id'].hashCode,
      sender.name,
      message.text,
      notificationDetails,
      payload: chatNotification.toJson(),
    );
  }

  @pragma('vm:entry-point')
  static void _handleNotificationAction(NotificationResponse response) async {
    final inputText = response.input;
    if (inputText == null) return;
    final chatNotificaiton = NotiChat.fromJson(response.payload!);

    final chat = Chat(
      id: const Uuid().v4(),
      toId: chatNotificaiton.senderId,
      fromId: chatNotificaiton.receiverId,
      msg: inputText,
      metadata: null,
      read: false,
      sentTime: DateTime.now().millisecondsSinceEpoch,
      status: MessageStatus.sent,
      readTime: null,
      type: ChatType.text,
    );

    try {
      final connectivity = Connectivity();
      if (!_isInitialize) {
        await Supabase.initialize(anonKey: anonKey, url: url);
        await LocalDatabase.initializeLocalDatabase();
        NetworkInfo.init(connectivity);
        _isInitialize = true;
      }
      final supabaseClient = Supabase.instance.client;

      final chatRemoteDataSource = ChatRemoteDataSourceImp(supabaseClient);

      final localDataBase = LocalDatabase.instance;
      final localDataSource = ChatLocalDataSourceImp(localDataBase);
      final networkInfo = NetworkInfo.instance;

      final chatRepository =
          ChatRepositoryImp(chatRemoteDataSource, localDataSource, networkInfo);
      final sendTextUseCase = SendTextUseCase(chatRepository);
      await sendTextUseCase(chat);
    } catch (e) {
      log('Error: $e');
    }
  }
}
