// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoDetailImpl _$$VideoDetailImplFromJson(Map<String, dynamic> json) =>
    _$VideoDetailImpl(
      status: json['status'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      duration: json['duration'] as String?,
      releaseDate: json['releaseDate'] as String?,
      actor: json['actor'] as String?,
      actorUrl: json['actorUrl'] as String?,
      playUrl: json['playUrl'] as String?,
      playKey: json['playKey'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$VideoDetailImplToJson(_$VideoDetailImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'duration': instance.duration,
      'releaseDate': instance.releaseDate,
      'actor': instance.actor,
      'actorUrl': instance.actorUrl,
      'playUrl': instance.playUrl,
      'playKey': instance.playKey,
      'error': instance.error,
    };

_$VideoDetailRequestImpl _$$VideoDetailRequestImplFromJson(
  Map<String, dynamic> json,
) => _$VideoDetailRequestImpl(videoId: json['videoId'] as String);

Map<String, dynamic> _$$VideoDetailRequestImplToJson(
  _$VideoDetailRequestImpl instance,
) => <String, dynamic>{'videoId': instance.videoId};
