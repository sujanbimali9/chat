// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) {
  return _MediaModel.fromJson(json);
}

/// @nodoc
mixin _$MediaModel {
  String get url => throw _privateConstructorUsedError;
  MediaMetaDataModel get metadata => throw _privateConstructorUsedError;
  MediaType get type => throw _privateConstructorUsedError;

  /// Serializes this MediaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaModelCopyWith<MediaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaModelCopyWith<$Res> {
  factory $MediaModelCopyWith(
    MediaModel value,
    $Res Function(MediaModel) then,
  ) = _$MediaModelCopyWithImpl<$Res, MediaModel>;
  @useResult
  $Res call({String url, MediaMetaDataModel metadata, MediaType type});

  $MediaMetaDataModelCopyWith<$Res> get metadata;
}

/// @nodoc
class _$MediaModelCopyWithImpl<$Res, $Val extends MediaModel>
    implements $MediaModelCopyWith<$Res> {
  _$MediaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? metadata = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as MediaMetaDataModel,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MediaType,
          )
          as $Val,
    );
  }

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MediaMetaDataModelCopyWith<$Res> get metadata {
    return $MediaMetaDataModelCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MediaModelImplCopyWith<$Res>
    implements $MediaModelCopyWith<$Res> {
  factory _$$MediaModelImplCopyWith(
    _$MediaModelImpl value,
    $Res Function(_$MediaModelImpl) then,
  ) = __$$MediaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, MediaMetaDataModel metadata, MediaType type});

  @override
  $MediaMetaDataModelCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$MediaModelImplCopyWithImpl<$Res>
    extends _$MediaModelCopyWithImpl<$Res, _$MediaModelImpl>
    implements _$$MediaModelImplCopyWith<$Res> {
  __$$MediaModelImplCopyWithImpl(
    _$MediaModelImpl _value,
    $Res Function(_$MediaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? metadata = null,
    Object? type = null,
  }) {
    return _then(
      _$MediaModelImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        metadata: null == metadata
            ? _value.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as MediaMetaDataModel,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MediaType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaModelImpl implements _MediaModel {
  _$MediaModelImpl({
    required this.url,
    required this.metadata,
    required this.type,
  });

  factory _$MediaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaModelImplFromJson(json);

  @override
  final String url;
  @override
  final MediaMetaDataModel metadata;
  @override
  final MediaType type;

  @override
  String toString() {
    return 'MediaModel(url: $url, metadata: $metadata, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaModelImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, metadata, type);

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaModelImplCopyWith<_$MediaModelImpl> get copyWith =>
      __$$MediaModelImplCopyWithImpl<_$MediaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaModelImplToJson(this);
  }
}

abstract class _MediaModel implements MediaModel {
  factory _MediaModel({
    required final String url,
    required final MediaMetaDataModel metadata,
    required final MediaType type,
  }) = _$MediaModelImpl;

  factory _MediaModel.fromJson(Map<String, dynamic> json) =
      _$MediaModelImpl.fromJson;

  @override
  String get url;
  @override
  MediaMetaDataModel get metadata;
  @override
  MediaType get type;

  /// Create a copy of MediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaModelImplCopyWith<_$MediaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
