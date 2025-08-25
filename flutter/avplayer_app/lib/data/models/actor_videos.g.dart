// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_videos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActorVideosImpl _$$ActorVideosImplFromJson(Map<String, dynamic> json) =>
    _$ActorVideosImpl(
      status: json['status'] as String,
      actorName: json['actorName'] as String?,
      videos: (json['videos'] as List<dynamic>)
          .map((e) => VideoListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$ActorVideosImplToJson(_$ActorVideosImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'actorName': instance.actorName,
      'videos': instance.videos,
      'totalCount': instance.totalCount,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'error': instance.error,
    };

_$ActorVideosRequestImpl _$$ActorVideosRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ActorVideosRequestImpl(
  actorUrl: json['actorUrl'] as String,
  page: (json['page'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$$ActorVideosRequestImplToJson(
  _$ActorVideosRequestImpl instance,
) => <String, dynamic>{'actorUrl': instance.actorUrl, 'page': instance.page};
