import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/video_list_item.dart';
import '../models/video_detail.dart';
import '../models/actor_videos.dart';

class VideoRepository {
  final ApiClient _apiClient;

  VideoRepository(this._apiClient);

  Future<VideoListResponse> getVideoList({int page = 1}) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.videos,
        queryParameters: {'page': page},
      );

      if (response.data != null) {
        return VideoListResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ApiException('無回應資料');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('獲取影片列表失敗：$e');
    }
  }

  Future<VideoDetail> getVideoDetail(String videoId) async {
    try {
      final request = VideoDetailRequest(videoId: videoId);
      final response = await _apiClient.post(
        ApiConstants.videoDetail,
        data: request.toJson(),
      );

      if (response.data != null) {
        return VideoDetail.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ApiException('無回應資料');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('獲取影片詳情失敗：$e');
    }
  }

  Future<ActorVideos> getActorVideos(String actorUrl, {int page = 1}) async {
    try {
      final request = ActorVideosRequest(actorUrl: actorUrl, page: page);
      final response = await _apiClient.post(
        ApiConstants.actorVideos,
        data: request.toJson(),
      );

      if (response.data != null) {
        return ActorVideos.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ApiException('無回應資料');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('獲取演員影片失敗：$e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await _apiClient.get(ApiConstants.health);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
