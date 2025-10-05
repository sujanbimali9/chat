// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return _ConversationHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$ConversationModel {
  ChatModel get chat => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;
  DateTime get lastInteractionAt => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
    ConversationModel value,
    $Res Function(ConversationModel) then,
  ) = _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call({
    ChatModel chat,
    UserModel user,
    DateTime lastInteractionAt,
    int unreadCount,
  });

  $ChatModelCopyWith<$Res> get chat;
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chat = null,
    Object? user = null,
    Object? lastInteractionAt = null,
    Object? unreadCount = null,
  }) {
    return _then(
      _value.copyWith(
            chat: null == chat
                ? _value.chat
                : chat // ignore: cast_nullable_to_non_nullable
                      as ChatModel,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            lastInteractionAt: null == lastInteractionAt
                ? _value.lastInteractionAt
                : lastInteractionAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatModelCopyWith<$Res> get chat {
    return $ChatModelCopyWith<$Res>(_value.chat, (value) {
      return _then(_value.copyWith(chat: value) as $Val);
    });
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationHistoryModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationHistoryModelImplCopyWith(
    _$ConversationHistoryModelImpl value,
    $Res Function(_$ConversationHistoryModelImpl) then,
  ) = __$$ConversationHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ChatModel chat,
    UserModel user,
    DateTime lastInteractionAt,
    int unreadCount,
  });

  @override
  $ChatModelCopyWith<$Res> get chat;
  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$ConversationHistoryModelImplCopyWithImpl<$Res>
    extends
        _$ConversationModelCopyWithImpl<$Res, _$ConversationHistoryModelImpl>
    implements _$$ConversationHistoryModelImplCopyWith<$Res> {
  __$$ConversationHistoryModelImplCopyWithImpl(
    _$ConversationHistoryModelImpl _value,
    $Res Function(_$ConversationHistoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chat = null,
    Object? user = null,
    Object? lastInteractionAt = null,
    Object? unreadCount = null,
  }) {
    return _then(
      _$ConversationHistoryModelImpl(
        chat: null == chat
            ? _value.chat
            : chat // ignore: cast_nullable_to_non_nullable
                  as ChatModel,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        lastInteractionAt: null == lastInteractionAt
            ? _value.lastInteractionAt
            : lastInteractionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationHistoryModelImpl implements _ConversationHistoryModel {
  const _$ConversationHistoryModelImpl({
    required this.chat,
    required this.user,
    required this.lastInteractionAt,
    required this.unreadCount,
  });

  factory _$ConversationHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationHistoryModelImplFromJson(json);

  @override
  final ChatModel chat;
  @override
  final UserModel user;
  @override
  final DateTime lastInteractionAt;
  @override
  final int unreadCount;

  @override
  String toString() {
    return 'ConversationModel(chat: $chat, user: $user, lastInteractionAt: $lastInteractionAt, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationHistoryModelImpl &&
            (identical(other.chat, chat) || other.chat == chat) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.lastInteractionAt, lastInteractionAt) ||
                other.lastInteractionAt == lastInteractionAt) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, chat, user, lastInteractionAt, unreadCount);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationHistoryModelImplCopyWith<_$ConversationHistoryModelImpl>
  get copyWith =>
      __$$ConversationHistoryModelImplCopyWithImpl<
        _$ConversationHistoryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationHistoryModelImplToJson(this);
  }
}

abstract class _ConversationHistoryModel implements ConversationModel {
  const factory _ConversationHistoryModel({
    required final ChatModel chat,
    required final UserModel user,
    required final DateTime lastInteractionAt,
    required final int unreadCount,
  }) = _$ConversationHistoryModelImpl;

  factory _ConversationHistoryModel.fromJson(Map<String, dynamic> json) =
      _$ConversationHistoryModelImpl.fromJson;

  @override
  ChatModel get chat;
  @override
  UserModel get user;
  @override
  DateTime get lastInteractionAt;
  @override
  int get unreadCount;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationHistoryModelImplCopyWith<_$ConversationHistoryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
