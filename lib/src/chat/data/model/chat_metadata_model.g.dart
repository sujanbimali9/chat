// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMetaDataModelImpl _$$ChatMetaDataModelImplFromJson(
  Map<String, dynamic> json,
) => _$ChatMetaDataModelImpl(
  aspectRatio: (json['aspectRatio'] as num?)?.toDouble(),
  thumbnail: json['thumbnail'] as String?,
  height: (json['height'] as num?)?.toDouble(),
  width: (json['width'] as num?)?.toDouble(),
  duration: (json['duration'] as num?)?.toInt(),
  title: json['title'] as String?,
);

Map<String, dynamic> _$$ChatMetaDataModelImplToJson(
  _$ChatMetaDataModelImpl instance,
) => <String, dynamic>{
  'aspectRatio': instance.aspectRatio,
  'thumbnail': instance.thumbnail,
  'height': instance.height,
  'width': instance.width,
  'duration': instance.duration,
  'title': instance.title,
};
