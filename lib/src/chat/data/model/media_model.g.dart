// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaModelImpl _$$MediaModelImplFromJson(Map<String, dynamic> json) =>
    _$MediaModelImpl(
      url: json['url'] as String,
      metadata: MediaMetaDataModel.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$MediaModelImplToJson(_$MediaModelImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'metadata': instance.metadata,
      'type': _$MediaTypeEnumMap[instance.type]!,
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.file: 'file',
};
