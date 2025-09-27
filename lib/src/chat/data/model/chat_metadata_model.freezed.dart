// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_metadata_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MediaMetaDataModel _$MediaMetaDataModelFromJson(Map<String, dynamic> json) {
  return _ChatMetaDataModel.fromJson(json);
}

/// @nodoc
mixin _$MediaMetaDataModel {
  double? get aspectRatio => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;

  /// Serializes this MediaMetaDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaMetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaMetaDataModelCopyWith<MediaMetaDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaMetaDataModelCopyWith<$Res> {
  factory $MediaMetaDataModelCopyWith(
    MediaMetaDataModel value,
    $Res Function(MediaMetaDataModel) then,
  ) = _$MediaMetaDataModelCopyWithImpl<$Res, MediaMetaDataModel>;
  @useResult
  $Res call({
    double? aspectRatio,
    String? thumbnail,
    double? height,
    double? width,
    int? duration,
    String? title,
  });
}

/// @nodoc
class _$MediaMetaDataModelCopyWithImpl<$Res, $Val extends MediaMetaDataModel>
    implements $MediaMetaDataModelCopyWith<$Res> {
  _$MediaMetaDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaMetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aspectRatio = freezed,
    Object? thumbnail = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? duration = freezed,
    Object? title = freezed,
  }) {
    return _then(
      _value.copyWith(
            aspectRatio: freezed == aspectRatio
                ? _value.aspectRatio
                : aspectRatio // ignore: cast_nullable_to_non_nullable
                      as double?,
            thumbnail: freezed == thumbnail
                ? _value.thumbnail
                : thumbnail // ignore: cast_nullable_to_non_nullable
                      as String?,
            height: freezed == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as double?,
            width: freezed == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as double?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatMetaDataModelImplCopyWith<$Res>
    implements $MediaMetaDataModelCopyWith<$Res> {
  factory _$$ChatMetaDataModelImplCopyWith(
    _$ChatMetaDataModelImpl value,
    $Res Function(_$ChatMetaDataModelImpl) then,
  ) = __$$ChatMetaDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double? aspectRatio,
    String? thumbnail,
    double? height,
    double? width,
    int? duration,
    String? title,
  });
}

/// @nodoc
class __$$ChatMetaDataModelImplCopyWithImpl<$Res>
    extends _$MediaMetaDataModelCopyWithImpl<$Res, _$ChatMetaDataModelImpl>
    implements _$$ChatMetaDataModelImplCopyWith<$Res> {
  __$$ChatMetaDataModelImplCopyWithImpl(
    _$ChatMetaDataModelImpl _value,
    $Res Function(_$ChatMetaDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaMetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aspectRatio = freezed,
    Object? thumbnail = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? duration = freezed,
    Object? title = freezed,
  }) {
    return _then(
      _$ChatMetaDataModelImpl(
        aspectRatio: freezed == aspectRatio
            ? _value.aspectRatio
            : aspectRatio // ignore: cast_nullable_to_non_nullable
                  as double?,
        thumbnail: freezed == thumbnail
            ? _value.thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as String?,
        height: freezed == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as double?,
        width: freezed == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as double?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMetaDataModelImpl implements _ChatMetaDataModel {
  _$ChatMetaDataModelImpl({
    this.aspectRatio,
    this.thumbnail,
    this.height,
    this.width,
    this.duration,
    this.title,
  });

  factory _$ChatMetaDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMetaDataModelImplFromJson(json);

  @override
  final double? aspectRatio;
  @override
  final String? thumbnail;
  @override
  final double? height;
  @override
  final double? width;
  @override
  final int? duration;
  @override
  final String? title;

  @override
  String toString() {
    return 'MediaMetaDataModel(aspectRatio: $aspectRatio, thumbnail: $thumbnail, height: $height, width: $width, duration: $duration, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMetaDataModelImpl &&
            (identical(other.aspectRatio, aspectRatio) ||
                other.aspectRatio == aspectRatio) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    aspectRatio,
    thumbnail,
    height,
    width,
    duration,
    title,
  );

  /// Create a copy of MediaMetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMetaDataModelImplCopyWith<_$ChatMetaDataModelImpl> get copyWith =>
      __$$ChatMetaDataModelImplCopyWithImpl<_$ChatMetaDataModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMetaDataModelImplToJson(this);
  }
}

abstract class _ChatMetaDataModel implements MediaMetaDataModel {
  factory _ChatMetaDataModel({
    final double? aspectRatio,
    final String? thumbnail,
    final double? height,
    final double? width,
    final int? duration,
    final String? title,
  }) = _$ChatMetaDataModelImpl;

  factory _ChatMetaDataModel.fromJson(Map<String, dynamic> json) =
      _$ChatMetaDataModelImpl.fromJson;

  @override
  double? get aspectRatio;
  @override
  String? get thumbnail;
  @override
  double? get height;
  @override
  double? get width;
  @override
  int? get duration;
  @override
  String? get title;

  /// Create a copy of MediaMetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMetaDataModelImplCopyWith<_$ChatMetaDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
