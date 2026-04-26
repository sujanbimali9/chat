import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat/core/common/model/conversation.dart';
import 'package:chat/core/common/model/pagination.dart';
import 'package:chat/src/auth/domain/usecases/logout.dart';
import 'package:chat/src/home/domain/usecases/get_conversation_history_user.dart';
import 'package:chat/src/home/domain/usecases/get_interactive_user_stream.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_history_event.dart';
part 'conversation_history_state.dart';
part 'conversation_history_bloc.freezed.dart';

class ConversationHistoryBloc
    extends Bloc<ConversationHistoryEvent, ConversationHistory> {
  final GetConverstationHistoryUserUseCase _getConversationHistoryUseCase;
  final GetConversationHistoryUseCaseStream
  _getConversationHistoryUseCaseStream;

  StreamSubscription<List<Conversation>>? _conversationStreamSubscription;

  ConversationPagination _pagination = const ConversationPagination(
    lastInteractedAt: null,
    limit: 20,
    total: 0,
  );

  final Map<String, Conversation> _conversationsMap = {};
  bool _isFetchingMore = false;

  ConversationHistoryBloc(
    this._getConversationHistoryUseCase,
    this._getConversationHistoryUseCaseStream,
  ) : super(const _Initial()) {
    on<ConversationHistoryEvent>(_onEvent);

    add(const ConversationHistoryEvent.getConversationHistory());

    _subscribeToConversationStream();
  }

  Future<void> _onEvent(
    ConversationHistoryEvent event,
    Emitter<ConversationHistory> emit,
  ) async {
    await event.map<FutureOr<void>>(
      getConversationHistory: (_) => _getConversationHistory(emit),
      refreshConversationHistory: (_) => _refreshConversationHistory(emit),
      fetchMoreConversationHistory: (_) => _fetchMoreConversations(emit),
      updateFromStream: (e) => _updateFromStream(emit, e.conversations),
    );
  }

  void _subscribeToConversationStream() {
    final result = _getConversationHistoryUseCaseStream(NoParams());

    result.fold(
      (failure) => log('Stream subscription failed: ${failure.message}'),
      (stream) {
        _conversationStreamSubscription = stream.listen((conversations) {
          add(ConversationHistoryEvent.updateFromStream(conversations));
        }, onError: (error) => log('Stream error: $error'));
      },
    );
  }

  Future<void> _getConversationHistory(
    Emitter<ConversationHistory> emit,
  ) async {
    emit(const ConversationHistory.loading());

    final localResult = await _getConversationHistoryUseCase(
      GetConversationParams(
        limit: _pagination.limit,
        lastInteractedAt: null,
        local: true,
      ),
    );

    localResult.fold(
      (failure) => log('Local fetch error: ${failure.message}'),
      (response) {
        _updateConversationsMap(response.data);
        _pagination = response.pagination;
        emit(ConversationHistory.loaded(_getSortedConversations()));
      },
    );

    final remoteResult = await _getConversationHistoryUseCase(
      GetConversationParams(
        limit: _pagination.limit,
        lastInteractedAt: null,
        local: false,
      ),
    );

    remoteResult.fold(
      (failure) {
        log('Remote fetch error: ${failure.message}');
        if (_conversationsMap.isNotEmpty) {
          emit(ConversationHistory.loaded(_getSortedConversations()));
        } else {
          emit(ConversationHistory.error(failure.message));
        }
      },
      (response) {
        _updateConversationsMap(response.data);
        _pagination = response.pagination;
        emit(ConversationHistory.loaded(_getSortedConversations()));
      },
    );
  }

  Future<void> _refreshConversationHistory(
    Emitter<ConversationHistory> emit,
  ) async {
    _conversationsMap.clear();
    _pagination = const ConversationPagination(
      lastInteractedAt: null,
      limit: 20,
      total: 0,
    );

    await _getConversationHistory(emit);
  }

  Future<void> _fetchMoreConversations(
    Emitter<ConversationHistory> emit,
  ) async {
    if (_isFetchingMore) return;

    if (!_hasMoreData()) {
      log('No more conversations to fetch');
      return;
    }

    _isFetchingMore = true;
    emit(ConversationHistory.fetchingMore(_getSortedConversations()));

    try {
      final localResult = await _getConversationHistoryUseCase(
        GetConversationParams(
          limit: _pagination.limit,
          lastInteractedAt: _pagination.lastInteractedAt,
          local: true,
        ),
      );
      ConversationPagination? localPagination;

      localResult.fold(
        (failure) => log('Local fetch error: ${failure.message}'),
        (response) {
          _updateConversationsMap(response.data);
          localPagination = response.pagination;
          emit(ConversationHistory.loaded(_getSortedConversations()));
        },
      );

      final remoteResult = await _getConversationHistoryUseCase(
        GetConversationParams(
          limit: _pagination.limit,
          lastInteractedAt: _pagination.lastInteractedAt,
          local: false,
        ),
      );

      remoteResult.fold(
        (failure) {
          if (localPagination != null) {
            _pagination = localPagination!;
          }
          log('Remote fetch error: ${failure.message}');
        },
        (response) {
          _updateConversationsMap(response.data);
          _pagination = response.pagination;
          emit(ConversationHistory.loaded(_getSortedConversations()));
        },
      );
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> _updateFromStream(
    Emitter<ConversationHistory> emit,
    List<Conversation> conversations,
  ) async {
    _updateConversationsMap(conversations);

    if (state is _Loaded || state is _FetchingMore) {
      emit(ConversationHistory.loaded(_getSortedConversations()));
    }
  }

  void _updateConversationsMap(List<Conversation> conversations) {
    for (final conversation in conversations) {
      final existingConversation = _conversationsMap[conversation.user.id];

      if (existingConversation == null ||
          conversation.lastInteractionAt.isAfter(
            existingConversation.lastInteractionAt,
          )) {
        _conversationsMap[conversation.user.id] = conversation;
      }
    }
  }

  List<Conversation> _getSortedConversations() {
    final conversations = _conversationsMap.values.toList();
    conversations.sort(
      (a, b) => b.lastInteractionAt.compareTo(a.lastInteractionAt),
    );
    return conversations;
  }

  bool _hasMoreData() {
    if (_pagination.lastInteractedAt == null && _conversationsMap.isNotEmpty) {
      return false;
    }

    if (_pagination.total > 0 &&
        _conversationsMap.length >= _pagination.total) {
      return false;
    }

    return true;
  }

  @override
  Future<void> close() {
    _conversationStreamSubscription?.cancel();
    return super.close();
  }
}
