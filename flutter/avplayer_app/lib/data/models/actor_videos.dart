import 'package:freezed_annotation/freezed_annotation.dart';
import 'video_list_item.dart';

part 'actor_videos.freezed.dart';
part 'actor_videos.g.dart';

@freezed
class ActorVideos with _$ActorVideos {
  const factory ActorVideos({
    required String status,
    String? actorName,
    required List<VideoListItem> videos,
    required int totalCount,
    required int currentPage,
    required int totalPages,
    String? error,
  }) = _ActorVideos;

  factory ActorVideos.fromJson(Map<String, dynamic> json) =>
      _$ActorVideosFromJson(json);
}

@freezed
class ActorVideosRequest with _$ActorVideosRequest {
  const factory ActorVideosRequest({
    required String actorUrl,
    @Default(1) int page,
  }) = _ActorVideosRequest;

  factory ActorVideosRequest.fromJson(Map<String, dynamic> json) =>
      _$ActorVideosRequestFromJson(json);
}
