import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_detail.freezed.dart';
part 'video_detail.g.dart';

@freezed
class VideoDetail with _$VideoDetail {
  const factory VideoDetail({
    required String status,
    String? title,
    String? description,
    String? imageUrl,
    String? duration,
    String? releaseDate,
    String? actor,
    String? actorUrl,
    String? playUrl,
    String? playKey,
    String? error,
  }) = _VideoDetail;

  factory VideoDetail.fromJson(Map<String, dynamic> json) =>
      _$VideoDetailFromJson(json);
}

@freezed
class VideoDetailRequest with _$VideoDetailRequest {
  const factory VideoDetailRequest({
    required String videoId,
  }) = _VideoDetailRequest;

  factory VideoDetailRequest.fromJson(Map<String, dynamic> json) =>
      _$VideoDetailRequestFromJson(json);
}
