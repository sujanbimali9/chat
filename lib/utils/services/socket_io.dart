import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIOService {
  static final SocketIOService _instance = SocketIOService._internal();
  factory SocketIOService() => _instance;
  SocketIOService._internal();

  static SocketIOService get instance => _instance;

  static StreamController<Map<String, dynamic>>? _chatStreamController;

  Stream<Map<String, dynamic>> get chatStream {
    _chatStreamController ??=
        StreamController<Map<String, dynamic>>.broadcast();
    return _chatStreamController!.stream;
  }

  static late Socket _socket;

  Future<void> init(String userId,
      {String url = 'http://192.168.1.22:8000'}) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      _socket = io(
        url,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setReconnectionDelay(5000)
            .setAuth({
              'userId': userId,
              'pushToken': token,
            })
            .build(),
      );

      _socket.on('message', (data) {
        _chatStreamController?.add(data);
      });

      _socket.on('connect_error', (error) {});

      _socket.on('disconnect', (_) {});
    } catch (e) {
      log('Error initializing socket: $e');
    }
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> data) async {
    return await _socket
        .emitWithAckAsync('sendMessage', data, ack: (data) {})
        .timeout(const Duration(seconds: 10));
  }

  void dispose() {
    _chatStreamController?.close();
    _socket.disconnect();
    _socket.clearListeners();
    _socket.dispose();
  }
}
