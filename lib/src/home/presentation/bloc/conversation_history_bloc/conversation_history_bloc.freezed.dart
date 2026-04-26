// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_history_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ConversationHistoryEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getConversationHistory,
    required TResult Function() refreshConversationHistory,
    required TResult Function() fetchMoreConversationHistory,
    required TResult Function(List<Conversation> conversations)
    updateFromStream,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getConversationHistory,
    TResult? Function()? refreshConversationHistory,
    TResult? Function()? fetchMoreConversationHistory,
    TResult? Function(List<Conversation> conversations)? updateFromStream,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getConversationHistory,
    TResult Function()? refreshConversationHistory,
    TResult Function()? fetchMoreConversationHistory,
    TResult Function(List<Conversation> conversations)? updateFromStream,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetConversationHistory value)
    getConversationHistory,
    required TResult Function(_RefreshConversationHistory value)
    refreshConversationHistory,
    required TResult Function(_FetchMoreConversationHistory value)
    fetchMoreConversationHistory,
    required TResult Function(_StateEmitter value) updateFromStream,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetConversationHistory value)? getConversationHistory,
    TResult? Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult? Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult? Function(_StateEmitter value)? updateFromStream,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetConversationHistory value)? getConversationHistory,
    TResult Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult Function(_StateEmitter value)? updateFromStream,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationHistoryEventCopyWith<$Res> {
  factory $ConversationHistoryEventCopyWith(
    ConversationHistoryEvent value,
    $Res Function(ConversationHistoryEvent) then,
  ) = _$ConversationHistoryEventCopyWithImpl<$Res, ConversationHistoryEvent>;
}

/// @nodoc
class _$ConversationHistoryEventCopyWithImpl<
  $Res,
  $Val extends ConversationHistoryEvent
>
    implements $ConversationHistoryEventCopyWith<$Res> {
  _$ConversationHistoryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GetConversationHistoryImplCopyWith<$Res> {
  factory _$$GetConversationHistoryImplCopyWith(
    _$GetConversationHistoryImpl value,
    $Res Function(_$GetConversationHistoryImpl) then,
  ) = __$$GetConversationHistoryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetConversationHistoryImplCopyWithImpl<$Res>
    extends
        _$ConversationHistoryEventCopyWithImpl<
          $Res,
          _$GetConversationHistoryImpl
        >
    implements _$$GetConversationHistoryImplCopyWith<$Res> {
  __$$GetConversationHistoryImplCopyWithImpl(
    _$GetConversationHistoryImpl _value,
    $Res Function(_$GetConversationHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetConversationHistoryImpl implements _GetConversationHistory {
  const _$GetConversationHistoryImpl();

  @override
  String toString() {
    return 'ConversationHistoryEvent.getConversationHistory()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetConversationHistoryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getConversationHistory,
    required TResult Function() refreshConversationHistory,
    required TResult Function() fetchMoreConversationHistory,
    required TResult Function(List<Conversation> conversations)
    updateFromStream,
  }) {
    return getConversationHistory();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getConversationHistory,
    TResult? Function()? refreshConversationHistory,
    TResult? Function()? fetchMoreConversationHistory,
    TResult? Function(List<Conversation> conversations)? updateFromStream,
  }) {
    return getConversationHistory?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getConversationHistory,
    TResult Function()? refreshConversationHistory,
    TResult Function()? fetchMoreConversationHistory,
    TResult Function(List<Conversation> conversations)? updateFromStream,
    required TResult orElse(),
  }) {
    if (getConversationHistory != null) {
      return getConversationHistory();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetConversationHistory value)
    getConversationHistory,
    required TResult Function(_RefreshConversationHistory value)
    refreshConversationHistory,
    required TResult Function(_FetchMoreConversationHistory value)
    fetchMoreConversationHistory,
    required TResult Function(_StateEmitter value) updateFromStream,
  }) {
    return getConversationHistory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetConversationHistory value)? getConversationHistory,
    TResult? Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult? Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult? Function(_StateEmitter value)? updateFromStream,
  }) {
    return getConversationHistory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetConversationHistory value)? getConversationHistory,
    TResult Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult Function(_StateEmitter value)? updateFromStream,
    required TResult orElse(),
  }) {
    if (getConversationHistory != null) {
      return getConversationHistory(this);
    }
    return orElse();
  }
}

abstract class _GetConversationHistory implements ConversationHistoryEvent {
  const factory _GetConversationHistory() = _$GetConversationHistoryImpl;
}

/// @nodoc
abstract class _$$RefreshConversationHistoryImplCopyWith<$Res> {
  factory _$$RefreshConversationHistoryImplCopyWith(
    _$RefreshConversationHistoryImpl value,
    $Res Function(_$RefreshConversationHistoryImpl) then,
  ) = __$$RefreshConversationHistoryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshConversationHistoryImplCopyWithImpl<$Res>
    extends
        _$ConversationHistoryEventCopyWithImpl<
          $Res,
          _$RefreshConversationHistoryImpl
        >
    implements _$$RefreshConversationHistoryImplCopyWith<$Res> {
  __$$RefreshConversationHistoryImplCopyWithImpl(
    _$RefreshConversationHistoryImpl _value,
    $Res Function(_$RefreshConversationHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshConversationHistoryImpl implements _RefreshConversationHistory {
  const _$RefreshConversationHistoryImpl();

  @override
  String toString() {
    return 'ConversationHistoryEvent.refreshConversationHistory()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshConversationHistoryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getConversationHistory,
    required TResult Function() refreshConversationHistory,
    required TResult Function() fetchMoreConversationHistory,
    required TResult Function(List<Conversation> conversations)
    updateFromStream,
  }) {
    return refreshConversationHistory();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getConversationHistory,
    TResult? Function()? refreshConversationHistory,
    TResult? Function()? fetchMoreConversationHistory,
    TResult? Function(List<Conversation> conversations)? updateFromStream,
  }) {
    return refreshConversationHistory?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getConversationHistory,
    TResult Function()? refreshConversationHistory,
    TResult Function()? fetchMoreConversationHistory,
    TResult Function(List<Conversation> conversations)? updateFromStream,
    required TResult orElse(),
  }) {
    if (refreshConversationHistory != null) {
      return refreshConversationHistory();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetConversationHistory value)
    getConversationHistory,
    required TResult Function(_RefreshConversationHistory value)
    refreshConversationHistory,
    required TResult Function(_FetchMoreConversationHistory value)
    fetchMoreConversationHistory,
    required TResult Function(_StateEmitter value) updateFromStream,
  }) {
    return refreshConversationHistory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetConversationHistory value)? getConversationHistory,
    TResult? Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult? Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult? Function(_StateEmitter value)? updateFromStream,
  }) {
    return refreshConversationHistory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetConversationHistory value)? getConversationHistory,
    TResult Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult Function(_StateEmitter value)? updateFromStream,
    required TResult orElse(),
  }) {
    if (refreshConversationHistory != null) {
      return refreshConversationHistory(this);
    }
    return orElse();
  }
}

abstract class _RefreshConversationHistory implements ConversationHistoryEvent {
  const factory _RefreshConversationHistory() =
      _$RefreshConversationHistoryImpl;
}

/// @nodoc
abstract class _$$FetchMoreConversationHistoryImplCopyWith<$Res> {
  factory _$$FetchMoreConversationHistoryImplCopyWith(
    _$FetchMoreConversationHistoryImpl value,
    $Res Function(_$FetchMoreConversationHistoryImpl) then,
  ) = __$$FetchMoreConversationHistoryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchMoreConversationHistoryImplCopyWithImpl<$Res>
    extends
        _$ConversationHistoryEventCopyWithImpl<
          $Res,
          _$FetchMoreConversationHistoryImpl
        >
    implements _$$FetchMoreConversationHistoryImplCopyWith<$Res> {
  __$$FetchMoreConversationHistoryImplCopyWithImpl(
    _$FetchMoreConversationHistoryImpl _value,
    $Res Function(_$FetchMoreConversationHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchMoreConversationHistoryImpl
    implements _FetchMoreConversationHistory {
  const _$FetchMoreConversationHistoryImpl();

  @override
  String toString() {
    return 'ConversationHistoryEvent.fetchMoreConversationHistory()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchMoreConversationHistoryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getConversationHistory,
    required TResult Function() refreshConversationHistory,
    required TResult Function() fetchMoreConversationHistory,
    required TResult Function(List<Conversation> conversations)
    updateFromStream,
  }) {
    return fetchMoreConversationHistory();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getConversationHistory,
    TResult? Function()? refreshConversationHistory,
    TResult? Function()? fetchMoreConversationHistory,
    TResult? Function(List<Conversation> conversations)? updateFromStream,
  }) {
    return fetchMoreConversationHistory?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getConversationHistory,
    TResult Function()? refreshConversationHistory,
    TResult Function()? fetchMoreConversationHistory,
    TResult Function(List<Conversation> conversations)? updateFromStream,
    required TResult orElse(),
  }) {
    if (fetchMoreConversationHistory != null) {
      return fetchMoreConversationHistory();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetConversationHistory value)
    getConversationHistory,
    required TResult Function(_RefreshConversationHistory value)
    refreshConversationHistory,
    required TResult Function(_FetchMoreConversationHistory value)
    fetchMoreConversationHistory,
    required TResult Function(_StateEmitter value) updateFromStream,
  }) {
    return fetchMoreConversationHistory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetConversationHistory value)? getConversationHistory,
    TResult? Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult? Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult? Function(_StateEmitter value)? updateFromStream,
  }) {
    return fetchMoreConversationHistory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetConversationHistory value)? getConversationHistory,
    TResult Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult Function(_StateEmitter value)? updateFromStream,
    required TResult orElse(),
  }) {
    if (fetchMoreConversationHistory != null) {
      return fetchMoreConversationHistory(this);
    }
    return orElse();
  }
}

abstract class _FetchMoreConversationHistory
    implements ConversationHistoryEvent {
  const factory _FetchMoreConversationHistory() =
      _$FetchMoreConversationHistoryImpl;
}

/// @nodoc
abstract class _$$StateEmitterImplCopyWith<$Res> {
  factory _$$StateEmitterImplCopyWith(
    _$StateEmitterImpl value,
    $Res Function(_$StateEmitterImpl) then,
  ) = __$$StateEmitterImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Conversation> conversations});
}

/// @nodoc
class __$$StateEmitterImplCopyWithImpl<$Res>
    extends _$ConversationHistoryEventCopyWithImpl<$Res, _$StateEmitterImpl>
    implements _$$StateEmitterImplCopyWith<$Res> {
  __$$StateEmitterImplCopyWithImpl(
    _$StateEmitterImpl _value,
    $Res Function(_$StateEmitterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? conversations = null}) {
    return _then(
      _$StateEmitterImpl(
        null == conversations
            ? _value._conversations
            : conversations // ignore: cast_nullable_to_non_nullable
                  as List<Conversation>,
      ),
    );
  }
}

/// @nodoc

class _$StateEmitterImpl implements _StateEmitter {
  const _$StateEmitterImpl(final List<Conversation> conversations)
    : _conversations = conversations;

  final List<Conversation> _conversations;
  @override
  List<Conversation> get conversations {
    if (_conversations is EqualUnmodifiableListView) return _conversations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversations);
  }

  @override
  String toString() {
    return 'ConversationHistoryEvent.updateFromStream(conversations: $conversations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateEmitterImpl &&
            const DeepCollectionEquality().equals(
              other._conversations,
              _conversations,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_conversations),
  );

  /// Create a copy of ConversationHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateEmitterImplCopyWith<_$StateEmitterImpl> get copyWith =>
      __$$StateEmitterImplCopyWithImpl<_$StateEmitterImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getConversationHistory,
    required TResult Function() refreshConversationHistory,
    required TResult Function() fetchMoreConversationHistory,
    required TResult Function(List<Conversation> conversations)
    updateFromStream,
  }) {
    return updateFromStream(conversations);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getConversationHistory,
    TResult? Function()? refreshConversationHistory,
    TResult? Function()? fetchMoreConversationHistory,
    TResult? Function(List<Conversation> conversations)? updateFromStream,
  }) {
    return updateFromStream?.call(conversations);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getConversationHistory,
    TResult Function()? refreshConversationHistory,
    TResult Function()? fetchMoreConversationHistory,
    TResult Function(List<Conversation> conversations)? updateFromStream,
    required TResult orElse(),
  }) {
    if (updateFromStream != null) {
      return updateFromStream(conversations);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetConversationHistory value)
    getConversationHistory,
    required TResult Function(_RefreshConversationHistory value)
    refreshConversationHistory,
    required TResult Function(_FetchMoreConversationHistory value)
    fetchMoreConversationHistory,
    required TResult Function(_StateEmitter value) updateFromStream,
  }) {
    return updateFromStream(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetConversationHistory value)? getConversationHistory,
    TResult? Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult? Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult? Function(_StateEmitter value)? updateFromStream,
  }) {
    return updateFromStream?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetConversationHistory value)? getConversationHistory,
    TResult Function(_RefreshConversationHistory value)?
    refreshConversationHistory,
    TResult Function(_FetchMoreConversationHistory value)?
    fetchMoreConversationHistory,
    TResult Function(_StateEmitter value)? updateFromStream,
    required TResult orElse(),
  }) {
    if (updateFromStream != null) {
      return updateFromStream(this);
    }
    return orElse();
  }
}

abstract class _StateEmitter implements ConversationHistoryEvent {
  const factory _StateEmitter(final List<Conversation> conversations) =
      _$StateEmitterImpl;

  List<Conversation> get conversations;

  /// Create a copy of ConversationHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateEmitterImplCopyWith<_$StateEmitterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ConversationHistory {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<Conversation> data) loaded,
    required TResult Function(List<Conversation> data) fetchingMore,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<Conversation> data)? loaded,
    TResult? Function(List<Conversation> data)? fetchingMore,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<Conversation> data)? loaded,
    TResult Function(List<Conversation> data)? fetchingMore,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_FetchingMore value) fetchingMore,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_FetchingMore value)? fetchingMore,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_FetchingMore value)? fetchingMore,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationHistoryCopyWith<$Res> {
  factory $ConversationHistoryCopyWith(
    ConversationHistory value,
    $Res Function(ConversationHistory) then,
  ) = _$ConversationHistoryCopyWithImpl<$Res, ConversationHistory>;
}

/// @nodoc
class _$ConversationHistoryCopyWithImpl<$Res, $Val extends ConversationHistory>
    implements $ConversationHistoryCopyWith<$Res> {
  _$ConversationHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ConversationHistoryCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ConversationHistory.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<Conversation> data) loaded,
    required TResult Function(List<Conversation> data) fetchingMore,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<Conversation> data)? loaded,
    TResult? Function(List<Conversation> data)? fetchingMore,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<Conversation> data)? loaded,
    TResult Function(List<Conversation> data)? fetchingMore,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_FetchingMore value) fetchingMore,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_FetchingMore value)? fetchingMore,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_FetchingMore value)? fetchingMore,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ConversationHistory {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$ConversationHistoryCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ConversationHistory.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<Conversation> data) loaded,
    required TResult Function(List<Conversation> data) fetchingMore,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<Conversation> data)? loaded,
    TResult? Function(List<Conversation> data)? fetchingMore,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<Conversation> data)? loaded,
    TResult Function(List<Conversation> data)? fetchingMore,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_FetchingMore value) fetchingMore,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_FetchingMore value)? fetchingMore,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_FetchingMore value)? fetchingMore,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements ConversationHistory {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ConversationHistoryCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ConversationHistory.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<Conversation> data) loaded,
    required TResult Function(List<Conversation> data) fetchingMore,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<Conversation> data)? loaded,
    TResult? Function(List<Conversation> data)? fetchingMore,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<Conversation> data)? loaded,
    TResult Function(List<Conversation> data)? fetchingMore,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_FetchingMore value) fetchingMore,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_FetchingMore value)? fetchingMore,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_FetchingMore value)? fetchingMore,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements ConversationHistory {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
    _$LoadedImpl value,
    $Res Function(_$LoadedImpl) then,
  ) = __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Conversation> data});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$ConversationHistoryCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
    _$LoadedImpl _value,
    $Res Function(_$LoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$LoadedImpl(
        null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<Conversation>,
      ),
    );
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(final List<Conversation> data) : _data = data;

  final List<Conversation> _data;
  @override
  List<Conversation> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'ConversationHistory.loaded(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<Conversation> data) loaded,
    required TResult Function(List<Conversation> data) fetchingMore,
  }) {
    return loaded(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<Conversation> data)? loaded,
    TResult? Function(List<Conversation> data)? fetchingMore,
  }) {
    return loaded?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<Conversation> data)? loaded,
    TResult Function(List<Conversation> data)? fetchingMore,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_FetchingMore value) fetchingMore,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_FetchingMore value)? fetchingMore,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_FetchingMore value)? fetchingMore,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements ConversationHistory {
  const factory _Loaded(final List<Conversation> data) = _$LoadedImpl;

  List<Conversation> get data;

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FetchingMoreImplCopyWith<$Res> {
  factory _$$FetchingMoreImplCopyWith(
    _$FetchingMoreImpl value,
    $Res Function(_$FetchingMoreImpl) then,
  ) = __$$FetchingMoreImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Conversation> data});
}

/// @nodoc
class __$$FetchingMoreImplCopyWithImpl<$Res>
    extends _$ConversationHistoryCopyWithImpl<$Res, _$FetchingMoreImpl>
    implements _$$FetchingMoreImplCopyWith<$Res> {
  __$$FetchingMoreImplCopyWithImpl(
    _$FetchingMoreImpl _value,
    $Res Function(_$FetchingMoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$FetchingMoreImpl(
        null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<Conversation>,
      ),
    );
  }
}

/// @nodoc

class _$FetchingMoreImpl implements _FetchingMore {
  const _$FetchingMoreImpl(final List<Conversation> data) : _data = data;

  final List<Conversation> _data;
  @override
  List<Conversation> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'ConversationHistory.fetchingMore(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchingMoreImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchingMoreImplCopyWith<_$FetchingMoreImpl> get copyWith =>
      __$$FetchingMoreImplCopyWithImpl<_$FetchingMoreImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<Conversation> data) loaded,
    required TResult Function(List<Conversation> data) fetchingMore,
  }) {
    return fetchingMore(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<Conversation> data)? loaded,
    TResult? Function(List<Conversation> data)? fetchingMore,
  }) {
    return fetchingMore?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<Conversation> data)? loaded,
    TResult Function(List<Conversation> data)? fetchingMore,
    required TResult orElse(),
  }) {
    if (fetchingMore != null) {
      return fetchingMore(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_FetchingMore value) fetchingMore,
  }) {
    return fetchingMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_FetchingMore value)? fetchingMore,
  }) {
    return fetchingMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_FetchingMore value)? fetchingMore,
    required TResult orElse(),
  }) {
    if (fetchingMore != null) {
      return fetchingMore(this);
    }
    return orElse();
  }
}

abstract class _FetchingMore implements ConversationHistory {
  const factory _FetchingMore(final List<Conversation> data) =
      _$FetchingMoreImpl;

  List<Conversation> get data;

  /// Create a copy of ConversationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchingMoreImplCopyWith<_$FetchingMoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
