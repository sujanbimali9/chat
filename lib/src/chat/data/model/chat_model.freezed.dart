// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return _ChatModel.fromJson(json);
}

/// @nodoc
mixin _$ChatModel {
  String get id => throw _privateConstructorUsedError;
  String get chatId => throw _privateConstructorUsedError;
  String get msg => throw _privateConstructorUsedError;
  bool get read => throw _privateConstructorUsedError;
  ChatType get type => throw _privateConstructorUsedError;
  String get toId => throw _privateConstructorUsedError;
  String get fromId => throw _privateConstructorUsedError;
  DateTime? get readTime => throw _privateConstructorUsedError;
  DateTime get sentTime => throw _privateConstructorUsedError;
  List<MediaModel> get medias => throw _privateConstructorUsedError;
  MessageStatus get status => throw _privateConstructorUsedError;
  ChatModel? get replyTo => throw _privateConstructorUsedError;

  /// Serializes this ChatModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatModelCopyWith<ChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatModelCopyWith<$Res> {
  factory $ChatModelCopyWith(ChatModel value, $Res Function(ChatModel) then) =
      _$ChatModelCopyWithImpl<$Res, ChatModel>;
  @useResult
  $Res call(
      {String id,
      String chatId,
      String msg,
      bool read,
      ChatType type,
      String toId,
      String fromId,
      DateTime? readTime,
      DateTime sentTime,
      List<MediaModel> medias,
      MessageStatus status,
      ChatModel? replyTo});

  $ChatModelCopyWith<$Res>? get replyTo;
}

/// @nodoc
class _$ChatModelCopyWithImpl<$Res, $Val extends ChatModel>
    implements $ChatModelCopyWith<$Res> {
  _$ChatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? msg = null,
    Object? read = null,
    Object? type = null,
    Object? toId = null,
    Object? fromId = null,
    Object? readTime = freezed,
    Object? sentTime = null,
    Object? medias = null,
    Object? status = null,
    Object? replyTo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatType,
      toId: null == toId
          ? _value.toId
          : toId // ignore: cast_nullable_to_non_nullable
              as String,
      fromId: null == fromId
          ? _value.fromId
          : fromId // ignore: cast_nullable_to_non_nullable
              as String,
      readTime: freezed == readTime
          ? _value.readTime
          : readTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentTime: null == sentTime
          ? _value.sentTime
          : sentTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      replyTo: freezed == replyTo
          ? _value.replyTo
          : replyTo // ignore: cast_nullable_to_non_nullable
              as ChatModel?,
    ) as $Val);
  }

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatModelCopyWith<$Res>? get replyTo {
    if (_value.replyTo == null) {
      return null;
    }

    return $ChatModelCopyWith<$Res>(_value.replyTo!, (value) {
      return _then(_value.copyWith(replyTo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatModelImplCopyWith<$Res>
    implements $ChatModelCopyWith<$Res> {
  factory _$$ChatModelImplCopyWith(
          _$ChatModelImpl value, $Res Function(_$ChatModelImpl) then) =
      __$$ChatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String chatId,
      String msg,
      bool read,
      ChatType type,
      String toId,
      String fromId,
      DateTime? readTime,
      DateTime sentTime,
      List<MediaModel> medias,
      MessageStatus status,
      ChatModel? replyTo});

  @override
  $ChatModelCopyWith<$Res>? get replyTo;
}

/// @nodoc
class __$$ChatModelImplCopyWithImpl<$Res>
    extends _$ChatModelCopyWithImpl<$Res, _$ChatModelImpl>
    implements _$$ChatModelImplCopyWith<$Res> {
  __$$ChatModelImplCopyWithImpl(
      _$ChatModelImpl _value, $Res Function(_$ChatModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? msg = null,
    Object? read = null,
    Object? type = null,
    Object? toId = null,
    Object? fromId = null,
    Object? readTime = freezed,
    Object? sentTime = null,
    Object? medias = null,
    Object? status = null,
    Object? replyTo = freezed,
  }) {
    return _then(_$ChatModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatType,
      toId: null == toId
          ? _value.toId
          : toId // ignore: cast_nullable_to_non_nullable
              as String,
      fromId: null == fromId
          ? _value.fromId
          : fromId // ignore: cast_nullable_to_non_nullable
              as String,
      readTime: freezed == readTime
          ? _value.readTime
          : readTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentTime: null == sentTime
          ? _value.sentTime
          : sentTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      replyTo: freezed == replyTo
          ? _value.replyTo
          : replyTo // ignore: cast_nullable_to_non_nullable
              as ChatModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatModelImpl implements _ChatModel {
  _$ChatModelImpl(
      {required this.id,
      required this.chatId,
      required this.msg,
      required this.read,
      required this.type,
      required this.toId,
      required this.fromId,
      this.readTime,
      required this.sentTime,
      required final List<MediaModel> medias,
      required this.status,
      this.replyTo})
      : _medias = medias;

  factory _$ChatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatModelImplFromJson(json);

  @override
  final String id;
  @override
  final String chatId;
  @override
  final String msg;
  @override
  final bool read;
  @override
  final ChatType type;
  @override
  final String toId;
  @override
  final String fromId;
  @override
  final DateTime? readTime;
  @override
  final DateTime sentTime;
  final List<MediaModel> _medias;
  @override
  List<MediaModel> get medias {
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  @override
  final MessageStatus status;
  @override
  final ChatModel? replyTo;

  @override
  String toString() {
    return 'ChatModel(id: $id, chatId: $chatId, msg: $msg, read: $read, type: $type, toId: $toId, fromId: $fromId, readTime: $readTime, sentTime: $sentTime, medias: $medias, status: $status, replyTo: $replyTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            (identical(other.read, read) || other.read == read) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.toId, toId) || other.toId == toId) &&
            (identical(other.fromId, fromId) || other.fromId == fromId) &&
            (identical(other.readTime, readTime) ||
                other.readTime == readTime) &&
            (identical(other.sentTime, sentTime) ||
                other.sentTime == sentTime) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.replyTo, replyTo) || other.replyTo == replyTo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      chatId,
      msg,
      read,
      type,
      toId,
      fromId,
      readTime,
      sentTime,
      const DeepCollectionEquality().hash(_medias),
      status,
      replyTo);

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      __$$ChatModelImplCopyWithImpl<_$ChatModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatModelImplToJson(
      this,
    );
  }
}

abstract class _ChatModel implements ChatModel {
  factory _ChatModel(
      {required final String id,
      required final String chatId,
      required final String msg,
      required final bool read,
      required final ChatType type,
      required final String toId,
      required final String fromId,
      final DateTime? readTime,
      required final DateTime sentTime,
      required final List<MediaModel> medias,
      required final MessageStatus status,
      final ChatModel? replyTo}) = _$ChatModelImpl;

  factory _ChatModel.fromJson(Map<String, dynamic> json) =
      _$ChatModelImpl.fromJson;

  @override
  String get id;
  @override
  String get chatId;
  @override
  String get msg;
  @override
  bool get read;
  @override
  ChatType get type;
  @override
  String get toId;
  @override
  String get fromId;
  @override
  DateTime? get readTime;
  @override
  DateTime get sentTime;
  @override
  List<MediaModel> get medias;
  @override
  MessageStatus get status;
  @override
  ChatModel? get replyTo;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
