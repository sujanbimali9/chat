import 'dart:async';

class GlobalEventBus {
  static final _controller = StreamController<AppEvent>.broadcast();
  static Stream<AppEvent> get stream => _controller.stream;
  static void emit(AppEvent event) => _controller.add(event);
}

sealed class AppEvent {}

class TokenExpiredEvent extends AppEvent {}
