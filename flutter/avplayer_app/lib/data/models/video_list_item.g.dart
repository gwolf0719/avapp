// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoListItemImpl _$$VideoListItemImplFromJson(Map<String, dynamic> json) =>
    _$VideoListItemImpl(
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      duration: json['duration'] as String?,
    );

Map<String, dynamic> _$$VideoListItemImplToJson(_$VideoListItemImpl instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'duration': instance.duration,
    };

_$VideoListResponseImpl _$$VideoListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$VideoListResponseImpl(
  status: json['status'] as String,
  videos: (json['videos'] as List<dynamic>)
      .map((e) => VideoListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  currentPage: (json['currentPage'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  error: json['error'] as String?,
);

Map<String, dynamic> _$$VideoListResponseImplToJson(
  _$VideoListResponseImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'videos': instance.videos,
  'totalCount': instance.totalCount,
  'currentPage': instance.currentPage,
  'totalPages': instance.totalPages,
  'error': instance.error,
};
