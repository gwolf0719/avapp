import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_list_item.freezed.dart';
part 'video_list_item.g.dart';

@freezed
class VideoListItem with _$VideoListItem {
  const factory VideoListItem({
    required String videoId,
    required String title,
    required String imageUrl,
    required String videoUrl,
    String? duration,
  }) = _VideoListItem;

  factory VideoListItem.fromJson(Map<String, dynamic> json) =>
      _$VideoListItemFromJson(json);
}

@freezed
class VideoListResponse with _$VideoListResponse {
  const factory VideoListResponse({
    required String status,
    required List<VideoListItem> videos,
    required int totalCount,
    required int currentPage,
    required int totalPages,
    String? error,
  }) = _VideoListResponse;

  factory VideoListResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoListResponseFromJson(json);
}
