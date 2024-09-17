import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkInfo {
  late final Connectivity _connectivity;
  static NetworkInfo? _instance;
  static StreamSubscription? _subscription;

  static bool _isOnline = false;
  NetworkInfo._();

  static NetworkInfo init(Connectivity connectivity) {
    assert(_instance == null, 'NetworkInfo is already initialized');
    if (kDebugMode) {
      print('NetworkInfo is initialized');
    }
    _instance = NetworkInfo._();
    _instance!._connectivity = connectivity;
    _instance!.listenConnection();
    return _instance!;
  }

  static NetworkInfo get instance {
    assert(_instance != null,
        'NetworkInfo instance is not initialized. Please call NetworkInfo.init()');
    return _instance!;
  }

  bool checkConnection() {
    return _isOnline;
  }

  void listenConnection() {
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      _isOnline = !event.contains(ConnectivityResult.none);
    });
  }

  static void dispose() {
    _subscription?.cancel();
    _instance = null;
  }
}
